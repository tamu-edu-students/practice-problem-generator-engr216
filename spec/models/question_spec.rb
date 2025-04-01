require 'rails_helper'

RSpec.describe Question, type: :model do
  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to serialize(:answer_choices).as(Array) }
  it { is_expected.to validate_presence_of(:category) }
  it { is_expected.to validate_presence_of(:question) }
end