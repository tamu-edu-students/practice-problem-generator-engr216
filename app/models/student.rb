class Student < ApplicationRecord
  # Associate each student with a teacher record.
  # (Mark optional if not every student must have a teacher.)
  belongs_to :teacher, optional: true

  validates :first_name, presence: true
  validates :last_name,  presence: true
  validates :email,      presence: true, uniqueness: true
  validates :uin,        presence: true,
                         length: { is: 9 },
                         numericality: { only_integer: true }
  # You can add validations for teacher (if stored as a string) or authenticate if needed.
end
