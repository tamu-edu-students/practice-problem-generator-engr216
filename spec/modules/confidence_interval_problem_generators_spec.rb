require 'rails_helper'

RSpec.describe ConfidenceIntervalProblemGenerators do
  # We need to test the actual parameter passing to reach 100% coverage
  let(:test_class) do
    Class.new do
      include ConfidenceIntervalQuestionText
      include ConfidenceIntervalProblemGenerators

      # More accurate stub for common parameter method
      def generate_common_parameters(mean_range, std_range, _size_range = 30..100)
        {
          sample_size: 50,
          sample_mean: mean_range.first / 10.0,
          pop_std: std_range.first / 10.0,
          confidence_level: 95
        }
      end

      # Stub method to verify correct parameter passing
      def calculate_bounds(params)
        # Need to test that calculate_bounds is called with all the right keys
        # Make sure params contains all the keys we expect
        raise 'Missing keys' unless %i[sample_mean pop_std sample_size confidence_level].all? do |k|
          params.key?(k)
        end

        [params[:sample_mean] - 5, params[:sample_mean] + 5]
      end

      # Stub for build_confidence_interval_problem with parameter verification
      def build_confidence_interval_problem(question_text, lower_bound, upper_bound, params)
        {
          type: 'confidence_interval',
          question: question_text,
          answers: { lower_bound: lower_bound, upper_bound: upper_bound },
          parameters: params
        }
      end

      # Stub text methods to verify parameter passing
      def battery_question_text(sample_size, sample_mean, pop_std, confidence_level)
        "Battery question with #{sample_size}, #{sample_mean}, #{pop_std}, #{confidence_level}"
      end

      def cereal_question_text(sample_size, sample_mean, pop_std, confidence_level)
        "Cereal question with #{sample_size}, #{sample_mean}, #{pop_std}, #{confidence_level}"
      end

      def waiting_times_question_text(sample_size, sample_mean, pop_std, confidence_level)
        "Waiting times question with #{sample_size}, #{sample_mean}, #{pop_std}, #{confidence_level}"
      end

      def car_mileage_question_text(sample_size, sample_mean, pop_std, confidence_level)
        "Car mileage question with #{sample_size}, #{sample_mean}, #{pop_std}, #{confidence_level}"
      end

      def produce_weight_question_text(sample_size, sample_mean, pop_std, confidence_level)
        "Produce weight question with #{sample_size}, #{sample_mean}, #{pop_std}, #{confidence_level}"
      end

      def shipping_times_question_text(sample_size, sample_mean, pop_std, confidence_level)
        "Shipping times question with #{sample_size}, #{sample_mean}, #{pop_std}, #{confidence_level}"
      end

      def manufacturing_diameter_question_text(sample_size, sample_mean, pop_std, confidence_level)
        "Manufacturing diameter question with #{sample_size}, #{sample_mean}, #{pop_std}, #{confidence_level}"
      end

      def concentration_question_text(sample_size, sample_mean, pop_std, confidence_level)
        "Concentration question with #{sample_size}, #{sample_mean}, #{pop_std}, #{confidence_level}"
      end

      def phone_call_duration_question_text(sample_size, sample_mean, pop_std, confidence_level)
        "Phone call duration question with #{sample_size}, #{sample_mean}, #{pop_std}, #{confidence_level}"
      end

      def daily_water_usage_question_text(sample_size, sample_mean, pop_std, confidence_level)
        "Daily water usage question with #{sample_size}, #{sample_mean}, #{pop_std}, #{confidence_level}"
      end

      # Deterministic test values
      # rubocop:disable Metrics/MethodLength
      def value_for_range(range)
        # Use predefined values for each range to ensure deterministic testing
        range_map = {
          # Sample size ranges
          (30..100) => 50, # Default sample_size
          (40..120) => 80, # Waiting times sample_size
          (30..80) => 60,  # Manufacturing sample_size

          # Mean ranges
          (950..1050) => 1000, # Battery mean
          (495..505) => 500,   # Cereal mean
          (120..250) => 200,   # Waiting times mean
          (220..320) => 300,   # Car mileage mean
          (150..250) => 200,   # Produce weight mean
          (24..72) => 48,      # Shipping times mean
          (45..55) => 50,      # Manufacturing mean
          (10..100) => 50,     # Concentration mean
          (150..450) => 300,   # Phone call mean
          (200..400) => 300,   # Daily water mean

          # Standard deviation ranges
          (120..220) => 150,   # Battery std
          (5..15) => 10,       # Cereal/shipping times std
          (30..60) => 45,      # Waiting times std
          (30..50) => 40,      # Car mileage std
          (20..40) => 30,      # Produce weight std
          (2..10) => 5,        # Manufacturing std
          (2..8) => 5,         # Concentration std
          (30..90) => 60,      # Phone call std
          (40..80) => 60       # Daily water std
        }

        range_map[range] || range.to_a.first
      end
      # rubocop:enable Metrics/MethodLength

      # Methods we need to override for deterministic testing
      def rand(range)
        value_for_range(range)
      end

      def sample
        95 # Default confidence level
      end
    end
  end

  let(:generator) { test_class.new }

  # Focus on full method call chain coverage with parameter verification
  shared_examples 'a problem generator with correct parameter flow' do |method_name, mean_range, std_range, size_range|
    let(:problem) { generator.send(method_name) }
    let(:params_args) { [mean_range, std_range, size_range].compact }

    context 'when generating parameters' do
      before do
        allow(generator).to receive(:generate_common_parameters).and_call_original
        generator.send(method_name)
      end

      it 'calls generate_common_parameters with correct ranges' do
        expect(generator).to have_received(:generate_common_parameters).with(*params_args)
      end
    end

    context 'when calculating bounds' do
      before do
        allow(generator).to receive(:calculate_bounds).and_call_original
        generator.send(method_name)
      end

      it 'calls calculate_bounds' do
        expect(generator).to have_received(:calculate_bounds)
      end
    end

    it 'builds a problem with correct type' do
      expect(problem[:type]).to eq('confidence_interval')
    end

    it 'passes parameters to question text method' do
      problem_type = method_name.to_s.gsub('generate_', '').gsub('_problem', '').split('_').first
      capitalized_type = problem_type.capitalize
      expect(problem[:question]).to include(capitalized_type)
    end
  end

  # Test each generator with specific range parameters
  describe '#generate_battery_lifetime_problem' do
    it_behaves_like 'a problem generator with correct parameter flow',
                    :generate_battery_lifetime_problem,
                    950..1050,
                    120..220
  end

  describe '#generate_cereal_box_fill_problem' do
    it_behaves_like 'a problem generator with correct parameter flow',
                    :generate_cereal_box_fill_problem,
                    495..505,
                    5..15
  end

  describe '#generate_waiting_times_problem' do
    it_behaves_like 'a problem generator with correct parameter flow',
                    :generate_waiting_times_problem,
                    120..250,
                    30..60,
                    40..120
  end

  describe '#generate_car_mileage_problem' do
    it_behaves_like 'a problem generator with correct parameter flow',
                    :generate_car_mileage_problem,
                    220..320,
                    30..50
  end

  describe '#generate_produce_weight_problem' do
    it_behaves_like 'a problem generator with correct parameter flow',
                    :generate_produce_weight_problem,
                    150..250,
                    20..40
  end

  describe '#generate_shipping_times_problem' do
    it_behaves_like 'a problem generator with correct parameter flow',
                    :generate_shipping_times_problem,
                    24..72,
                    5..15
  end

  describe '#generate_manufacturing_diameter_problem' do
    it_behaves_like 'a problem generator with correct parameter flow',
                    :generate_manufacturing_diameter_problem,
                    45..55,
                    2..10,
                    30..80
  end

  describe '#generate_concentration_problem' do
    it_behaves_like 'a problem generator with correct parameter flow',
                    :generate_concentration_problem,
                    10..100,
                    2..8
  end

  describe '#generate_phone_call_duration_problem' do
    it_behaves_like 'a problem generator with correct parameter flow',
                    :generate_phone_call_duration_problem,
                    150..450,
                    30..90
  end

  describe '#generate_daily_water_usage_problem' do
    it_behaves_like 'a problem generator with correct parameter flow',
                    :generate_daily_water_usage_problem,
                    200..400,
                    40..80
  end

  # Test parameter unpacking into text methods
  describe 'parameter unpacking' do
    let(:params) do
      {
        sample_size: 50,
        sample_mean: 100.0,
        pop_std: 10.0,
        confidence_level: 95
      }
    end

    before do
      allow(generator).to receive_messages(
        battery_question_text: 'Test text',
        generate_common_parameters: params
      )
    end

    it 'calls the question text method with unpacked parameters' do
      generator.generate_battery_lifetime_problem
      expect(generator).to have_received(:battery_question_text)
        .with(50, 100.0, 10.0, 95)
    end

    it 'correctly passes parameters for generating battery lifetime problem' do
      generator.generate_battery_lifetime_problem
      expect(generator).to have_received(:generate_common_parameters)
    end
  end
end
