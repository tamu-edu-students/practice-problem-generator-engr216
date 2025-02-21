class Student < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :uin, presence: true,
                  length: { is: 9 },
                  numericality: { only_integer: true }

  # has_one :student_statistic, dependent: :destroy
  has_many :student_category_statistics, class_name: "StudentCategoryStatistics", dependent: :destroy
  has_many :categories, through: :student_category_statistics
end
