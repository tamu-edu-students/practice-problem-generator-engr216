class Teacher < ApplicationRecord
  # A teacher may have many students.
  has_many :students, dependent: :nullify

  validates :name,  presence: true
  validates :email, presence: true, uniqueness: true,
                    format: { with: /\A[\w+\-.]+@tamu\.edu\z/i,
                              message: :invalid_domain }
end
