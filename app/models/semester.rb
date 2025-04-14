class Semester < ApplicationRecord
  has_many :students, dependent: :nullify

  validates :name, presence: true, uniqueness: true
  validates :active, inclusion: { in: [true, false] }

  scope :active, -> { where(active: true) }

  def self.current
    active.order(created_at: :desc).first
  end
end
