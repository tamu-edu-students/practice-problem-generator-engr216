class Question < ApplicationRecord
  # A question can have multiple answers.
  has_many :answers, dependent: :destroy

  # Basic validations to ensure necessary fields are present.
  validates :category, presence: true
  validates :question, presence: true
end
