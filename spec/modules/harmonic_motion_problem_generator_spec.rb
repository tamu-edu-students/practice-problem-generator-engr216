require 'rails_helper'

RSpec.describe HarmonicMotionProblemGenerator, type: :model do
  subject(:generator) { described_class.new('Harmonic Motion') }

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

  describe 'private method: generate_shm_problem_from_data' do
    context "when input_type is 'fill_in' and answer is a numeric string" do
      let(:data) do
        {
          question: 'What is the period?',
          answer: '1.23',
          input_type: 'fill_in',
          field_label: 'Period'
        }
      end

      it 'creates a single text input field' do
        result = generator.send(:generate_shm_problem_from_data, data)
        expect(result[:input_fields]).to eq([
                                              { label: 'Period', key: 'shm_answer', type: 'text' }
                                            ])
      end
    end

    context "when input_type is 'fill_in' and answer is an array of numeric values" do
      let(:data) do
        {
          question: 'Calculate two values:',
          answer: ['3.14', '2.71'],
          input_type: 'fill_in'
        }
      end

      it 'creates one text input per numeric answer' do
        result = generator.send(:generate_shm_problem_from_data, data)
        expect(result[:input_fields]).to eq([
                                              { label: 'Answer part 1', key: 'shm_answer_1', type: 'text' },
                                              { label: 'Answer part 2', key: 'shm_answer_2', type: 'text' }
                                            ])
      end
    end

    context "when input_type is 'fill_in' and answer is non-numeric" do
      let(:data) do
        {
          question: 'Select the correct option:',
          answer: 'A',
          input_type: 'fill_in',
          options: [
            { value: 'A', label: 'Option A' },
            { value: 'B', label: 'Option B' }
          ]
        }
      end

      it 'creates a radio input field' do
        result = generator.send(:generate_shm_problem_from_data, data)
        expect(result[:input_fields]).to eq([
                                              { label: 'Your Answer', key: 'shm_answer', type: 'radio',
                                                options: data[:options] }
                                            ])
      end
    end

    context "when input_type is 'multiple_choice'" do
      let(:data) do
        {
          question: 'Choose the correct relation:',
          answer: 'A',
          input_type: 'multiple_choice',
          options: [
            { value: 'A', label: 'T = 2π/ω' },
            { value: 'B', label: 'T = ω/2π' }
          ]
        }
      end

      it 'creates a radio input field' do
        result = generator.send(:generate_shm_problem_from_data, data)
        expect(result[:input_fields]).to eq([
                                              { label: 'Your Answer', key: 'shm_answer', type: 'radio',
                                                options: data[:options] }
                                            ])
      end
    end

    context "when input_type is 'multiple_choice' but answer is numeric" do
      let(:data) do
        {
          question: 'Numeric question as multiple choice:',
          answer: '1.23',
          input_type: 'multiple_choice',
          options: [
            { value: '1.23', label: '1.23' },
            { value: '2.34', label: '2.34' }
          ]
        }
      end

      it 'creates a radio input field even though answer is numeric' do
        result = generator.send(:generate_shm_problem_from_data, data)
        expect(result[:input_fields]).to eq([
                                              { label: 'Your Answer', key: 'shm_answer', type: 'radio',
                                                options: data[:options] }
                                            ])
      end
    end
  end

  describe 'static_questions' do
    it 'returns an array of 5 static questions with multiple choice input', :aggregate_failures do
      static_qs = generator.send(:static_questions)
      expect(static_qs).to be_an(Array)
      expect(static_qs.size).to eq(5)
      static_qs.each do |q|
        expect(q).to have_key(:question)
        expect(q).to have_key(:answer)
        expect(q).to have_key(:input_fields)
        expect(q[:input_fields].first[:type]).to eq('radio')
      end
    end
  end

  describe 'dynamic_questions' do
    it 'returns an array of 10 dynamic questions', :aggregate_failures do
      dynamic_qs = generator.send(:dynamic_questions)
      expect(dynamic_qs).to be_an(Array)
      expect(dynamic_qs.size).to eq(10)
      dynamic_qs.each do |q|
        expect(q).to have_key(:question)
        expect(q).to have_key(:answer)
        expect(q).to have_key(:input_fields)
        actual_field_type = q[:input_fields].first[:type]
        expect(actual_field_type).to be_in(%w[text radio])
      end
    end
  end
end
