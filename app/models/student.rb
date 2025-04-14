class Student < ApplicationRecord
  # Associate each student with a teacher record.
  # (Mark optional if not every student must have a teacher.)
  belongs_to :teacher, optional: true
  belongs_to :semester, optional: true

  validates :first_name, presence: true
  validates :last_name,  presence: true
  validates :email,      presence: true, uniqueness: true
  validates :uin,        presence: true,
                         length: { is: 9 },
                         numericality: { only_integer: true }
  # Semester validation removed - it will be set through update_uin

  # scope to find students by semester
  scope :by_semester, ->(semester_id) { where(semester_id: semester_id) if semester_id.present? }

  # You can add validations for teacher (if stored as a string) or authenticate if needed.
end
