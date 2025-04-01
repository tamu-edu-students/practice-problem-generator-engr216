# spec/models/angular_momentum_problem_generator_spec.rb
require 'rails_helper'

RSpec.describe AngularMomentumProblemGenerator, type: :model do
  subject(:generator) { described_class.new('Angular Momentum') }

  describe '#generate_questions' do
    it 'returns an array with one question', :aggregate_failures do
      questions = generator.generate_questions
      expect(questions).to be_an(Array)
      expect(questions.size).to eq(1)
      question = questions.first
      expect(question).to have_key(:question)
      expect(question).to have_key(:answer)
      expect(question).to have_key(:input_fields)
    end
  end

  describe 'private method: generate_am_problem_from_data' do
    context "when input_type is 'fill_in' and answer is a numeric string" do
      let(:data) do
        {
          question: 'Calculate angular momentum',
          answer: '5.67',
          input_type: 'fill_in',
          field_label: 'Angular Momentum'
        }
      end

      it 'creates a single text input field' do
        result = generator.send(:generate_am_problem_from_data, data)
        expect(result[:input_fields]).to eq([
                                              { label: 'Angular Momentum', key: 'am_answer', type: 'text' }
                                            ])
      end
    end

    context "when input_type is 'fill_in' and answer is an array of numeric strings" do
      let(:data) do
        {
          question: 'Find both components',
          answer: ['2.0', '4.0'],
          input_type: 'fill_in'
        }
      end

      it 'creates multiple text inputs for each numeric part' do
        result = generator.send(:generate_am_problem_from_data, data)
        expect(result[:input_fields]).to eq([
                                              { label: 'Answer part 1', key: 'am_answer_1', type: 'text' },
                                              { label: 'Answer part 2', key: 'am_answer_2', type: 'text' }
                                            ])
      end
    end

    context "when input_type is 'fill_in' and answer is a non-numeric string" do
      let(:data) do
        {
          question: 'Which option is correct?',
          answer: 'A',
          input_type: 'fill_in',
          options: [
            { value: 'A', label: 'Option A' },
            { value: 'B', label: 'Option B' }
          ]
        }
      end

      it 'creates a radio input field with options' do
        result = generator.send(:generate_am_problem_from_data, data)
        expect(result[:input_fields]).to eq([
                                              { label: 'Your Answer', key: 'am_answer', type: 'radio',
                                                options: data[:options] }
                                            ])
      end
    end

    context "when input_type is 'multiple_choice'" do
      let(:data) do
        {
          question: 'Angular equation select',
          answer: 'A',
          input_type: 'multiple_choice',
          options: [
            { value: 'A', label: '√(g(1 - cos(θ)) / r)' },
            { value: 'B', label: 'gθ / r' }
          ]
        }
      end

      it 'creates a multiple choice field' do
        result = generator.send(:generate_am_problem_from_data, data)
        expect(result[:input_fields]).to eq([
                                              { label: 'Your Answer', key: 'am_answer', type: 'radio',
                                                options: data[:options] }
                                            ])
      end
    end
  end

  describe 'static_questions' do
    it 'returns an array of 9 static questions with input_fields', :aggregate_failures do
      static_qs = generator.send(:static_questions)
      expect(static_qs).to be_an(Array)
      expect(static_qs.size).to eq(9)
      static_qs.each do |q|
        expect(q).to have_key(:question)
        expect(q).to have_key(:answer)
        expect(q).to have_key(:input_fields)
        expect(q[:input_fields]).to be_an(Array)
      end
    end

    it 'includes at least one multiple choice question' do
      static_qs = generator.send(:static_questions)
      has_radio = static_qs.any? do |q|
        q[:input_fields].any? { |field| field[:type] == 'radio' }
      end
      expect(has_radio).to be true
    end
  end

  describe 'dynamic_questions' do
    it 'returns an array of 2 dynamic questions with input_fields', :aggregate_failures do
      dynamic_qs = generator.send(:dynamic_questions)
      expect(dynamic_qs).to be_an(Array)
      expect(dynamic_qs.size).to eq(2)
      dynamic_qs.each do |q|
        expect(q).to have_key(:question)
        expect(q).to have_key(:answer)
        expect(q).to have_key(:input_fields)
        expect(q[:input_fields].first[:type]).to eq('text')
      end
    end
  end

  describe '#numeric?' do
    it 'returns true for numeric strings' do
      expect(generator.send(:numeric?, '3.14')).to be true
      expect(generator.send(:numeric?, '-10')).to be true
    end

    it 'returns false for non-numeric strings' do
      expect(generator.send(:numeric?, 'hello')).to be false
      expect(generator.send(:numeric?, nil)).to be false
    end
  end
end
