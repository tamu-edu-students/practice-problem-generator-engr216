class Student < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :uin, presence: true,
                  length: { is: 9 },
                  numericality: { only_integer: true }
end
