require 'rails_helper'

RSpec.describe EngineeringEthicsProblemGenerator do
  let(:generator) { described_class.new('Engineering Ethics') }

  describe '#initialize' do
    it 'sets the category' do
      expect(generator.instance_variable_get(:@category)).to eq('Engineering Ethics')
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
    
    it 'returns engineering ethics questions' do
      expect(questions[0][:type]).to eq('engineering_ethics')
    end
  end

  describe 'generated question structure' do
    let(:question) { generator.generate_questions.first }
    
    it 'includes required keys' do
      expect(question).to have_key(:question)
      expect(question).to have_key(:answer)
    end
    
    it 'has a non-empty question' do
      expect(question[:question]).to be_a(String)
      expect(question[:question]).not_to be_empty
    end
    
    it 'has a boolean answer' do
      expect(question[:answer]).to be(true).or be(false)
    end
    
    it 'includes input fields' do
      expect(question).to have_key(:input_fields)
    end
  end
end
