class Installation < ApplicationRecord
  belongs_to :technician, optional: true

  VALID_STATUSES = %w[pending assigned in_progress completed cancelled].freeze   

  validates :customer_name, presence: true
  validates :customer_address, presence: true
  validates :scheduled_date, presence: true
  validates :status, inclusion: { in: VALID_STATUSES }


  enum :status, { 
    pending: 'pending', 
    assigned: 'assigned', 
    in_progress: 'in_progress',
    completed: 'completed', 
    cancelled: 'cancelled' 
  }, default: :pending

  validate :scheduled_time_within_work_hours

  scope :pending, -> { where(status: 'pending') }
  scope :assigned, -> { where(status: 'assigned') }
  scope :completed, -> { where(status: 'completed') }
  scope :for_date, ->(date) { where(scheduled_date: date) }
  scope :for_technician, ->(tech_id) { where(technician_id: tech_id) }

  private

  def scheduled_time_within_work_hours
    return unless scheduled_time
    if scheduled_time.hour < 8 || scheduled_time.hour >= 17
      errors.add(:scheduled_time, "debe estar entre las 8:00 AM y las 5:00 PM")
    end
  end
end

