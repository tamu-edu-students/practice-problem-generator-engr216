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
    let(:question) { generator.generate_questions.first }

    it 'returns an array' do
      questions = generator.generate_questions
      expect(questions).to be_an(Array)
    end

    it 'returns an array with a single question' do
      questions = generator.generate_questions
      expect(questions.length).to eq(1)
    end

    it 'generates a question of type propagation of error' do
      expect(question[:type]).to eq('propagation of error')
    end

    it 'includes a question text' do
      expect(question[:question]).to be_a(String)
    end

    it 'includes a non-empty question text' do
      expect(question[:question]).not_to be_empty
    end

    it 'includes an answer' do
      expect(question[:answer]).to be_a(String)
    end

    it 'includes a non-empty answer' do
      expect(question[:answer]).not_to be_empty
    end

    it 'includes input fields' do
      expect(question[:input_fields]).to be_an(Array)
    end

    it 'includes at least one input field' do
      expect(question[:input_fields].length).to be > 0
    end

    it 'calls the correct module methods based on random selection' do
      allow(ErrorPropagationProblemGenerators).to receive(:send).with(anything).and_call_original
      generator.generate_questions
      expect(ErrorPropagationProblemGenerators).to have_received(:send).with(anything)
    end
  end

  describe 'private methods' do
    describe '#generate_problem_from_data' do
      let(:problem_data) do
        {
          question: 'Sample problem',
          answer: '42',
          explanation: 'Sample explanation',
          field_label: 'Uncertainty Value'
        }
      end

      it 'formats problem with correct type' do
        result = generator.send(:generate_problem_from_data, problem_data)
        expect(result[:type]).to eq('propagation of error')
      end

      it 'formats problem with correct question' do
        result = generator.send(:generate_problem_from_data, problem_data)
        expect(result[:question]).to eq('Sample problem')
      end

      it 'formats problem with correct answer' do
        result = generator.send(:generate_problem_from_data, problem_data)
        expect(result[:answer]).to eq('42')
      end

      it 'formats problem with correct explanation' do
        result = generator.send(:generate_problem_from_data, problem_data)
        expect(result[:explanation]).to eq('Sample explanation')
      end

      it 'formats problem with correct input field label' do
        result = generator.send(:generate_problem_from_data, problem_data)
        expect(result[:input_fields].first[:label]).to eq('Uncertainty Value')
      end
    end

    describe '#single_variable_problems' do
      it 'calls the correct module method' do
        mock_return = [{
          question: 'Q1',
          answer: '10',
          field_label: 'Label'
        }]

        allow(ErrorPropagationProblemGenerators).to receive(:single_variable_problems)
          .and_return(mock_return)

        generator.send(:single_variable_problems)
        expect(ErrorPropagationProblemGenerators).to have_received(:single_variable_problems)
      end

      it 'maps results correctly' do
        mock_return = [{
          question: 'Q1',
          answer: '10',
          field_label: 'Label'
        }]

        allow(ErrorPropagationProblemGenerators).to receive(:single_variable_problems)
          .and_return(mock_return)

        result = generator.send(:single_variable_problems)
        expect(result.first[:type]).to eq('propagation of error')
      end
    end

    describe '#multi_variable_problems' do
      it 'calls the correct module method' do
        mock_return = [{
          question: 'Q1',
          answer: '10',
          field_label: 'Label'
        }]

        allow(ErrorPropagationProblemGenerators).to receive(:multi_variable_problems)
          .and_return(mock_return)

        generator.send(:multi_variable_problems)
        expect(ErrorPropagationProblemGenerators).to have_received(:multi_variable_problems)
      end

      it 'maps results correctly' do
        mock_return = [{
          question: 'Q1',
          answer: '10',
          field_label: 'Label'
        }]

        allow(ErrorPropagationProblemGenerators).to receive(:multi_variable_problems)
          .and_return(mock_return)

        result = generator.send(:multi_variable_problems)
        expect(result.first[:type]).to eq('propagation of error')
      end
    end

    describe '#fractional_error_problems' do
      it 'calls the correct module method' do
        mock_return = [{
          question: 'Q1',
          answer: '10',
          field_label: 'Label'
        }]

        allow(ErrorPropagationProblemGenerators).to receive(:fractional_error_problems)
          .and_return(mock_return)

        generator.send(:fractional_error_problems)
        expect(ErrorPropagationProblemGenerators).to have_received(:fractional_error_problems)
      end

      it 'maps results correctly' do
        mock_return = [{
          question: 'Q1',
          answer: '10',
          field_label: 'Label'
        }]

        allow(ErrorPropagationProblemGenerators).to receive(:fractional_error_problems)
          .and_return(mock_return)

        result = generator.send(:fractional_error_problems)
        expect(result.first[:type]).to eq('propagation of error')
      end
    end
  end
end
