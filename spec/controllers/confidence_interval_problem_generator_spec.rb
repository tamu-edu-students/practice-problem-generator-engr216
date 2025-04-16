require 'rails_helper'

RSpec.describe ConfidenceIntervalProblemGenerator, type: :model do
  let(:generator) { described_class.new('Confidence Intervals') }

  describe '#generate_questions' do
    it 'returns a single confidence interval problem' do
      allow(generator).to receive(:generate_confidence_interval_problem).and_return({ type: 'confidence_interval' })
      questions = generator.generate_questions
      expect(questions.first[:type]).to eq('confidence_interval')
    end
  end

  describe '#generate_confidence_interval_problem' do
    context 'when selecting a generator method' do
      let(:generators) do
        %i[
          battery_lifetime cereal_box_fill waiting_times
          car_mileage produce_weight shipping_times
          manufacturing_diameter concentration
          phone_call_duration daily_water_usage
        ]
      end

      before do
        allow(generators).to receive(:sample).and_return(:battery_lifetime)
        allow(generator).to receive_messages(generator_list: generators,
                                             generate_battery_lifetime_problem: { type: 'confidence_interval' })
      end

      it 'calls the selected generator method' do
        generator.send(:generate_confidence_interval_problem)
        expect(generator).to have_received(:generate_battery_lifetime_problem)
      end

      it 'samples from the generator list' do
        generator.send(:generate_confidence_interval_problem)
        expect(generators).to have_received(:sample)
      end
    end
  end

  describe '#calculate_confidence_interval' do
    let(:sample_mean) { 100 }
    let(:pop_std) { 15 }
    let(:sample_size) { 36 }

    it 'calculates confidence intervals correctly' do
      confidence_level = 95
      lower, _upper = generator.send(:calculate_confidence_interval, sample_mean, pop_std, sample_size,
                                     confidence_level)
      expect(lower).to be_within(0.1).of(95.1)
    end

    it 'handles different confidence levels' do
      lower90, = generator.send(:calculate_confidence_interval, sample_mean, pop_std, sample_size, 90)
      lower99, = generator.send(:calculate_confidence_interval, sample_mean, pop_std, sample_size, 99)
      expect(lower90).not_to eq(lower99)
    end
  end

  describe '#confidence_z_value' do
    it 'returns correct z-values for a standard confidence level' do
      expect(generator.send(:confidence_z_value, 95)).to eq(1.96)
    end

    it 'defaults to 1.96 for unknown confidence levels' do
      expect(generator.send(:confidence_z_value, 80)).to eq(1.96)
    end
  end

  describe '#build_confidence_interval_problem' do
    let(:question) { 'Sample question' }
    let(:lower) { 95.5 }
    let(:upper) { 105.5 }
    let(:params) { { sample_size: 40, sample_mean: 100, pop_std: 15, confidence_level: 95 } }

    it 'builds a problem with the correct structure' do
      problem = generator.send(:build_confidence_interval_problem, question, lower, upper, 1, params)
      expect(problem[:type]).to eq('confidence_interval')
    end
  end

  describe '#generate_battery_lifetime_problem' do
    it 'generates a valid battery lifetime problem' do
      expect(generator.generate_battery_lifetime_problem[:type]).to eq('confidence_interval')
    end
  end

  describe '#generate_cereal_box_fill_problem' do
    it 'generates a valid cereal box problem' do
      expect(generator.generate_cereal_box_fill_problem[:type]).to eq('confidence_interval')
    end
  end

  describe '#generate_waiting_times_problem' do
    it 'generates a valid waiting times problem' do
      expect(generator.generate_waiting_times_problem[:type]).to eq('confidence_interval')
    end
  end

  describe '#generate_car_mileage_problem' do
    it 'generates a valid car mileage problem' do
      expect(generator.generate_car_mileage_problem[:type]).to eq('confidence_interval')
    end
  end

  describe '#generate_common_parameters' do
    it 'generates parameters within the specified ranges' do
      params = generator.send(:generate_common_parameters, 900..1100, 50..150, 30..100)
      expect(params).to have_key(:sample_size)
    end
  end
end
