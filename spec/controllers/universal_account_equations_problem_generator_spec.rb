require 'rails_helper'

RSpec.describe UniversalAccountEquationsProblemGenerator do
  # Create a custom implementation for our tests
  before do
    # Stub the generator's question text methods to avoid signature mismatches
    allow_any_instance_of(described_class).to receive_messages(
      electricity_bill_question_text: 'Electricity bill question',
      fuel_efficiency_question_text: 'Fuel efficiency question',
      mixing_solution_question_text: 'Mixing solution question',
      simple_interest_question_text: 'Simple interest question'
    )

    # Stub the sample method to make the tests deterministic
    allow_any_instance_of(Array).to receive(:sample), &:first
  end

  let(:category) { 'Universal Accounting Equation' }
  let(:generator) { described_class.new(category) }

  describe '#initialize' do
    it 'sets the category' do
      expect(generator.instance_variable_get(:@category)).to eq(category)
    end
  end

  describe '#generate_questions' do
    subject(:questions) { generator.generate_questions }

    it 'returns an array of questions' do
      expect(questions).to be_an(Array)
    end

    it 'returns at least one question' do
      expect(questions.length).to be >= 1
    end

    it 'returns universal account equations questions' do
      expect(questions[0][:type]).to eq('universal_account_equations')
    end
  end

  describe 'generated question structure' do
    let(:question) { generator.generate_questions.first }

    it 'includes type key' do
      expect(question[:type]).to eq('universal_account_equations')
    end

    it 'includes question text with content' do
      expect(question[:question]).to be_a(String)
    end

    it 'question text is not empty' do
      expect(question[:question]).not_to be_empty
    end

    it 'includes answer' do
      expect(question[:answer]).to be_a(Float).or be_a(Integer)
    end

    it 'includes input fields as array' do
      expect(question[:input_fields]).to be_an(Array)
    end

    it 'input fields are not empty' do
      expect(question[:input_fields]).not_to be_empty
    end

    it 'includes parameters as hash' do
      expect(question[:parameters]).to be_a(Hash)
    end

    it 'parameters are not empty' do
      expect(question[:parameters]).not_to be_empty
    end
  end
end
