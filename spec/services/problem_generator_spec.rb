# spec/services/problem_generator_spec.rb
require 'rails_helper'

RSpec.describe ProblemGenerator, type: :service do
  let(:category) { Category.create!(name: 'Physics') }
  let(:problem_generator) { described_class.new(category) }

  describe '#initialize' do
    it 'assigns the category' do
      expect(problem_generator.instance_variable_get(:@category)).to eq(category)
    end
  end

  describe '#generate_questions' do
    it 'returns an array of questions' do
      expect(problem_generator.generate_questions).to be_an(Array)
    end

    it 'returns the expected dummy questions' do
      expect(problem_generator.generate_questions).to match_array(described_class::QUESTIONS)
    end

    it 'each question has question, choices, and answer keys' do
      expect(problem_generator.generate_questions).to all(include(:question, :choices, :answer))
    end
  end

  describe 'QUESTIONS constant' do
    it 'is frozen (immutable)' do
      expect { described_class::QUESTIONS << { question: 'New Q?', choices: [], answer: '' } }
        .to raise_error(FrozenError)
    end
  end
end
