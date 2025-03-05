class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  serialize :answer_choices, type: Array, coder: YAML
  validates :category, presence: true
  validates :question, presence: true
end
