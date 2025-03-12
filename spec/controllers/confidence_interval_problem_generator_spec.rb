require 'rails_helper'

RSpec.describe ConfidenceIntervalProblemGenerator do
  let(:category) { 'Confidence Intervals' }
  let(:generator) { described_class.new(category) }

  describe '#generate_questions' do
    subject(:questions) { generator.generate_questions }

    it 'returns an array with exactly one problem' do
      expect(questions.length).to eq(1)
    end

    it 'returns a confidence interval problem' do
      expect(questions[0][:type]).to eq('confidence_interval')
    end
  end

  describe '#calculate_confidence_interval' do
    # Reduce number of memoized helpers by moving shared ones up
    let(:sample_size) { 36 }

    # Test each confidence level in separate contexts with minimal helpers
    context 'with 95% confidence level' do
      let(:result) do
        generator.send(
          :calculate_confidence_interval,
          100, 15, sample_size, 95
        )
      end

      it 'correctly calculates the lower bound' do
        expect(result[0]).to be_within(0.1).of(95.1)
      end

      it 'correctly calculates the upper bound' do
        expect(result[1]).to be_within(0.1).of(104.9)
      end
    end

    context 'with 90% confidence level' do
      let(:result) do
        generator.send(
          :calculate_confidence_interval,
          200, 30, 64, 90
        )
      end

      it 'correctly calculates the lower bound' do
        expect(result[0]).to be_within(0.1).of(193.83)
      end

      it 'correctly calculates the upper bound' do
        expect(result[1]).to be_within(0.1).of(206.17)
      end
    end

    context 'with 99% confidence level' do
      let(:result) do
        generator.send(
          :calculate_confidence_interval,
          50, 5, 100, 99
        )
      end

      it 'correctly calculates the lower bound' do
        expect(result[0]).to be_within(0.1).of(48.71)
      end

      it 'correctly calculates the upper bound' do
        expect(result[1]).to be_within(0.1).of(51.29)
      end
    end
  end

  # Test one problem generator as representative of all
  describe '#generate_battery_lifetime_problem' do
    let(:problem) { generator.send(:generate_battery_lifetime_problem) }

    it 'has the confidence_interval type' do
      expect(problem[:type]).to eq('confidence_interval')
    end

    # Split multiple expectations into separate tests
    it 'includes battery terminology in the question' do
      expect(problem[:question]).to include('batteries')
    end

    it 'mentions confidence interval in the question' do
      expect(problem[:question]).to include('confidence interval')
    end

    it 'provides a lower bound' do
      expect(problem[:answers][:lower_bound]).to be_a(Float)
    end

    it 'provides an upper bound' do
      expect(problem[:answers][:upper_bound]).to be_a(Float)
    end

    it 'ensures upper bound exceeds lower bound' do
      expect(problem[:answers][:upper_bound]).to be > problem[:answers][:lower_bound]
    end

    it 'includes input field for lower bound' do
      expect(problem[:input_fields][0][:key]).to eq('lower_bound')
    end

    it 'includes input field for upper bound' do
      expect(problem[:input_fields][1][:key]).to eq('upper_bound')
    end
  end

  # Test the build_confidence_interval_problem method with fewer let statements
  describe '#build_confidence_interval_problem' do
    # Reduce number of memoized helpers
    let(:problem) do
      question_text = 'Sample question text'
      generator.send(:build_confidence_interval_problem, question_text, 10.123, 20.456)
    end

    it 'sets the correct problem type' do
      expect(problem[:type]).to eq('confidence_interval')
    end

    it 'preserves the question text' do
      expect(problem[:question]).to eq('Sample question text')
    end

    it 'rounds the lower bound to 2 decimals' do
      expect(problem[:answers][:lower_bound]).to eq(10.12)
    end

    it 'rounds the upper bound to 2 decimals' do
      expect(problem[:answers][:upper_bound]).to eq(20.46)
    end

    it 'creates exactly two input fields' do
      expect(problem[:input_fields].size).to eq(2)
    end
  end
end
