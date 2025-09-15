class Technician < ApplicationRecord
  has_many :installations, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, format: { with: /\A[\+]?[\d\s\-\(\)\.]{7,20}\z/, message: "Formato inválido" }, allow_blank: true

  scope :active, -> { where(active: true) }

  def full_name
    name
  end
end