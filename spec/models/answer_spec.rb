require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { is_expected.to belong_to(:question).optional }
  it { is_expected.to serialize(:answer_choices) }
  it { is_expected.to validate_presence_of(:question_description) }
  it { is_expected.to validate_presence_of(:answer_choices) }
  it { is_expected.to validate_presence_of(:answer) }
  it { is_expected.to validate_presence_of(:student_email) }
end