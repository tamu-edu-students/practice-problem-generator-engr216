require 'rails_helper'

RSpec.describe ErrorPropagationProblemGenerator do
  let(:category) { 'propagation of error' }
  let(:generator) { described_class.new(category) }

  describe '#initialize' do
    it 'sets the category' do
      expect(generator.category).to eq(category)
    end
  end

  describe '#generate_questions' do
    it 'returns an array with a single question' do
      questions = generator.generate_questions
      expect(questions).to be_an(Array)
      expect(questions.length).to eq(1)
    end

    it 'generates a question of type propagation of error' do
      question = generator.generate_questions.first
      expect(question[:type]).to eq('propagation of error')
    end

    it 'includes a question text' do
      question = generator.generate_questions.first
      expect(question[:question]).to be_a(String)
      expect(question[:question]).not_to be_empty
    end

    it 'includes an answer' do
      question = generator.generate_questions.first
      expect(question[:answer]).to be_a(String)
      expect(question[:answer]).not_to be_empty
    end

    it 'includes input fields' do
      question = generator.generate_questions.first
      expect(question[:input_fields]).to be_an(Array)
      expect(question[:input_fields].length).to be > 0
    end
  end
end 