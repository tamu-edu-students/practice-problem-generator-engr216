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
    let(:question_text) { 'Sample question text' }
    let(:problem) do
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

    # Add tests from the second block
    context 'with complete problem data' do
      it 'correctly structures the problem data with accurate rounding' do
        question = 'Sample question text'
        lower = 10.5
        upper = 20.5

        problem = generator.send(:build_confidence_interval_problem, question, lower, upper)
        expect(problem[:answers][:lower_bound]).to eq(lower.round(2))
      end
    end
  end

  # Tests for problem generators not currently covered
  describe 'problem generators' do
    %i[generate_car_mileage_problem
       generate_produce_weight_problem
       generate_shipping_times_problem
       generate_manufacturing_diameter_problem
       generate_phone_call_duration_problem
       generate_daily_water_usage_problem].each do |method|
      describe "##{method}" do
        it 'generates a valid problem with correct structure' do
          problem = generator.send(method)

          expect(problem[:answers][:upper_bound]).to be > problem[:answers][:lower_bound]
        end
      end
    end
  end

  # Test formatting methods to ensure they generate correct text
  describe 'question text formatting methods' do
    # Split the test into more focused examples with fewer lines each
    %i[car_mileage_question_text
       produce_weight_question_text
       shipping_times_question_text
       manufacturing_diameter_question_text
       phone_call_duration_question_text
       daily_water_usage_question_text].each do |method|
      context "with #{method.to_s.gsub('_question_text', '')}" do
        # Split into three separate, focused examples
        it 'includes sample size in question text' do
          sample_size = 50
          text = generator.send(method, sample_size, 100.0, 15.0, 95)
          expect(text).to include(sample_size.to_s)
        end

        it 'includes confidence level percentage' do
          confidence_level = 95
          text = generator.send(method, 50, 100.0, 15.0, confidence_level)
          expect(text).to include("#{confidence_level}%")
        end

        it 'mentions confidence interval concept' do
          text = generator.send(method, 50, 100.0, 15.0, 95)
          expect(text).to include('confidence interval')
        end

        # Skip statistical parameter checks for daily water usage
        unless method == :daily_water_usage_question_text
          it 'includes sample mean in question text' do
            sample_mean = 100.0
            text = generator.send(method, 50, sample_mean, 15.0, 95)
            expect(text).to include(sample_mean.to_s)
          end

          it 'includes standard deviation in question text' do
            pop_std = 15.0
            text = generator.send(method, 50, 100.0, pop_std, 95)
            expect(text).to include(pop_std.to_s)
          end
        end
      end
    end
  end

  # Test helper methods that might not be covered
  describe '#rounding_instructions' do
    let(:instructions) { generator.send(:rounding_instructions) }

    it 'includes instructions to round values' do
      expect(instructions).to include('Round')
    end

    it 'specifies the number of decimal places for rounding' do
      expect(instructions).to include('decimal places')
    end

    it 'instructs not to include units in answers' do
      expect(instructions).to include('Do not include units')
    end
  end

  describe '#input_field_data' do
    it 'returns correctly structured input fields' do
      fields = generator.send(:input_field_data)

      expect(fields[1][:key]).to eq('upper_bound')
    end
  end

  describe '#answer_data' do
    it 'correctly formats and rounds the answer data' do
      lower = 10.555
      upper = 20.666

      data = generator.send(:answer_data, lower, upper)

      expect(data[:lower_bound]).to eq(10.56)
    end
  end
end
