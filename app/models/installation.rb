class Installation < ApplicationRecord
  belongs_to :technician, optional: true

  VALID_STATUSES = %w[pending assigned completed cancelled].freeze
  WORK_START_HOUR = 8  # 8:00 AM
  WORK_END_HOUR = 17   # 5:00 PM

  validates :customer_name, presence: true
  validates :customer_address, presence: true
  validates :scheduled_date, presence: true
  validates :start_time, presence: true
  validates :duration_hours, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :status, inclusion: { in: VALID_STATUSES }

  # Enum correcto para Rails 8
  enum :status, { 
    pending: 'pending', 
    assigned: 'assigned', 
    completed: 'completed', 
    cancelled: 'cancelled' 
  }, default: :pending

  validate :start_time_within_work_hours
  validate :end_time_within_work_hours
  validate :no_overlapping_installations, if: :technician_present?

  scope :pending, -> { where(status: 'pending') }
  scope :assigned, -> { where(status: 'assigned') }
  scope :completed, -> { where(status: 'completed') }
  scope :for_date, ->(date) { where(scheduled_date: date) }
  scope :for_technician, ->(tech_id) { where(technician_id: tech_id) }

  def end_time
    start_time + duration_hours.hours
  end

  def end_time_with_travel
    end_time + 1.hour  
  end

  private

  def start_time_within_work_hours
    return unless start_time

    if start_time.hour < WORK_START_HOUR
      errors.add(:start_time, "debe ser después de las 8:00 AM")
    end
  end

  def end_time_within_work_hours
    return unless start_time && duration_hours

    end_hour = (start_time + duration_hours.hours).hour
    if end_hour > WORK_END_HOUR
      errors.add(:duration_hours, "la instalación debe terminar antes de las 5:00 PM")
    end
  end

  def technician_present?
    technician_id.present?
  end

  def no_overlapping_installations
    return unless technician_id && scheduled_date && start_time && duration_hours

    overlapping = Installation.where(technician: technician, scheduled_date: scheduled_date)
                             .where.not(id: id)
                             .where.not(status: ['cancelled', 'completed'])

    overlapping.each do |installation|
      if times_overlap?(installation)
        errors.add(:base, "El técnico ya tiene una instalación programada en ese horario")
        break
      end
    end
  end

  def times_overlap?(other_installation)
    # Considerar tiempo de viaje
    my_start = start_time
    my_end = end_time_with_travel
    other_start = other_installation.start_time
    other_end = other_installation.end_time_with_travel

    my_start < other_end && other_start < my_end
  end
end

