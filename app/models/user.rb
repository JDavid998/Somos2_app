class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

 
  enum :role, { admin: 'admin', technician: 'technician' }, default: 'admin'


  validates :name, presence: true
  validates :role, presence: true


  def admin?
    role == 'admin'
  end

  def technician?
    role == 'technician'
  end
end

