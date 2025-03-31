class Answer < ApplicationRecord
  belongs_to :question, optional: true
  serialize :answer_choices, coder: YAML

  validates :question_description, presence: true
  validates :answer_choices,       presence: true
  validates :answer,               presence: true
  validates :student_email,        presence: true
end
