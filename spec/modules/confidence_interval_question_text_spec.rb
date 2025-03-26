require 'rails_helper'

RSpec.describe ConfidenceIntervalQuestionText do
  let(:test_class) { Class.new { include ConfidenceIntervalQuestionText } }
  let(:formatter) { test_class.new }

  describe '#battery_question_text' do
    it 'formats battery lifetime question with parameters' do
      expect(formatter.battery_question_text(40, 1000, 180, 95)).to include('battery lifetime')
    end

    it 'includes sample size in text' do
      expect(formatter.battery_question_text(40, 1000, 180, 95)).to include('sample of 40 batteries')
    end

    it 'includes mean in text' do
      expect(formatter.battery_question_text(40, 1000, 180, 95)).to include('mean lifetime is 1000')
    end
  end

  describe '#cereal_question_text' do
    it 'formats cereal box question with parameters' do
      expect(formatter.cereal_question_text(36, 500, 10, 95)).to include('cereal')
    end

    it 'includes sample size in text' do
      expect(formatter.cereal_question_text(36, 500, 10, 95)).to include('sample of 36 boxes')
    end
  end

  describe '#waiting_times_question_text' do
    it 'includes wait time parameters in the text' do
      expect(formatter.waiting_times_question_text(25, 18.5, 4.2, 90)).to include('wait time')
    end

    it 'includes confidence level in text' do
      expect(formatter.waiting_times_question_text(25, 18.5, 4.2, 90)).to include('90%')
    end
  end

  describe '#car_mileage_question_text' do
    it 'formats car mileage question with parameters' do
      expect(formatter.car_mileage_question_text(30, 32.5, 4.5, 95)).to include('fuel efficiency')
    end

    it 'includes sample size in text' do
      expect(formatter.car_mileage_question_text(30, 32.5, 4.5, 95)).to include('sample of 30 cars')
    end
  end

  describe '#produce_weight_question_text' do
    it 'formats produce weight question with parameters' do
      expect(formatter.produce_weight_question_text(40, 150.5, 25.0, 95)).to include('produce')
    end

    it 'includes mean weight in text' do
      expect(formatter.produce_weight_question_text(40, 150.5, 25.0, 95)).to include('150.5 grams')
    end
  end

  describe '#shipping_times_question_text' do
    it 'formats shipping times question with parameters' do
      expect(formatter.shipping_times_question_text(50, 48.0, 8.0, 95)).to include('shipping')
    end

    it 'includes delivery time in text' do
      expect(formatter.shipping_times_question_text(50, 48.0, 8.0, 95)).to include('48.0 hours')
    end
  end

  describe '#manufacturing_diameter_question_text' do
    it 'formats manufacturing diameter question with parameters' do
      expect(formatter.manufacturing_diameter_question_text(45, 10.5, 1.2, 95)).to include('diameter')
    end

    it 'includes sample size in text' do
      expect(formatter.manufacturing_diameter_question_text(45, 10.5, 1.2,
                                                            95)).to include('measures the diameter of 45 parts')
    end
  end

  describe '#concentration_question_text' do
    it 'formats concentration question with parameters' do
      expect(formatter.concentration_question_text(35, 25.5, 3.0, 95)).to include('concentration')
    end

    it 'includes mean concentration in text' do
      expect(formatter.concentration_question_text(35, 25.5, 3.0, 95)).to include('25.5 ppm')
    end
  end

  describe '#phone_call_duration_question_text' do
    it 'formats phone call duration question with parameters' do
      expect(formatter.phone_call_duration_question_text(60, 180.0, 30.0, 95)).to include('phone calls')
    end

    it 'includes call duration in text' do
      expect(formatter.phone_call_duration_question_text(60, 180.0, 30.0, 95)).to include('180.0 seconds')
    end
  end

  describe '#daily_water_usage_question_text' do
    it 'formats daily water usage question with parameters' do
      expect(formatter.daily_water_usage_question_text(100, 250.0, 50.0, 95)).to include('water usage')
    end

    it 'includes sample size in text' do
      expect(formatter.daily_water_usage_question_text(100, 250.0, 50.0, 95)).to include('100 households')
    end
  end

  describe '#format_confidence_level' do
    it 'formats different confidence levels' do
      expect(formatter.format_confidence_level(95)).to eq('95%')
    end

    it 'formats single-digit confidence levels' do
      expect(formatter.format_confidence_level(9)).to eq('9%')
    end
  end

  describe '#rounding_instructions' do
    it 'includes decimal places instruction' do
      expect(formatter.rounding_instructions).to include('two (2) decimal places')
    end

    it 'includes no units instruction' do
      expect(formatter.rounding_instructions).to include('Do not include units')
    end

    it 'includes no scientific notation instruction' do
      expect(formatter.rounding_instructions).to include('Do not use scientific notation')
    end
  end

  describe '#format_number' do
    it 'formats whole numbers as integers' do
      expect(formatter.format_number(100)).to eq('100')
    end

    it 'formats decimal numbers with one decimal place' do
      expect(formatter.format_number(10.25)).to eq('10.3')
    end

    it 'handles zero correctly' do
      expect(formatter.format_number(0)).to eq('0')
    end

    it 'handles very small numbers correctly' do
      expect(formatter.format_number(0.01)).to eq('0.0')
    end
  end
end
