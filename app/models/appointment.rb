class Appointment < ApplicationRecord
  belongs_to :user
  belongs_to :doctor

  # validations
  validates :date_of_appointment, presence: true
end
