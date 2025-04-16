require 'rails_helper'

RSpec.describe UniversalAccountEquationsProblemGenerators do
  # Create a mock test class that includes the module and stubs question text methods
  let(:test_class) do
    Class.new do
      include UniversalAccountEquationsProblemGenerators

      # Stub the question text methods to accept any number of arguments
      def roller_coaster_velocity_question_text(*_args)
        'Roller coaster question'
      end

      def jam_production_cost_question_text(*_args)
        'Jam production question'
      end

      def fuel_efficiency_question_text(*_args)
        'Fuel efficiency question'
      end

      def mixing_solution_question_text(*_args)
        'Mixing solution question'
      end

      def simple_interest_question_text(*_args)
        'Simple interest question'
      end

      def electricity_bill_question_text(*_args)
        'Electricity bill question'
      end

      def weight_conversion_question_text(*_args)
        'Weight conversion question'
      end

      def rounding_instructions
        'Round to 2 decimal places'
      end
    end.new
  end

  describe '#build_uae_problem' do
    subject(:problem) { test_class.build_uae_problem(question_text, answer, 1, params) }

    let(:question_text) { 'Test question' }
    let(:answer) { 42.12345 }
    let(:params) { { param1: 'value1', param2: 'value2' } }

    it 'returns a hash' do
      expect(problem).to be_a(Hash)
    end

    it 'sets the correct type' do
      expect(problem[:type]).to eq('universal_account_equations')
    end

    it 'sets the question text' do
      expect(problem[:question]).to eq(question_text)
    end

    it 'rounds the answer to 2 decimal places' do
      expect(problem[:answer]).to eq(42.12)
    end

    it 'includes input fields' do
      expect(problem[:input_fields]).to be_a(Array)
    end

    it 'includes parameters' do
      expect(problem[:parameters]).to eq(params)
    end
  end

  describe '#input_field_data' do
    subject(:input_fields) { test_class.input_field_data }

    it 'returns an array' do
      expect(input_fields).to be_a(Array)
    end

    it 'contains a single input field' do
      expect(input_fields.size).to eq(1)
    end

    it 'sets the correct label and key' do
      expect(input_fields.first).to include(label: 'Answer', key: 'answer')
    end
  end

  describe '#generate_roller_coaster_velocity_problem' do
    subject(:roller_coaster_problem) { test_class.generate_roller_coaster_velocity_problem }

    it 'returns a hash' do
      expect(roller_coaster_problem).to be_a(Hash)
    end

    it 'sets the correct type' do
      expect(roller_coaster_problem[:type]).to eq('universal_account_equations')
    end

    it 'includes a question string' do
      expect(roller_coaster_problem[:question]).to be_a(String)
    end

    it 'includes a float answer' do
      expect(roller_coaster_problem[:answer]).to be_a(Float)
    end

    it 'includes input fields' do
      expect(roller_coaster_problem[:input_fields]).to be_a(Array)
    end

    it 'includes parameters' do
      expect(roller_coaster_problem[:parameters]).to be_a(Hash)
    end

    it 'includes necessary parameters' do
      expect(roller_coaster_problem[:parameters]).to include(:mass, :height, :distance, :drag_force)
    end

    it 'calculates velocity correctly' do
      # Extract parameters for verification
      mass = roller_coaster_problem[:parameters][:mass]
      height = roller_coaster_problem[:parameters][:height]
      distance = roller_coaster_problem[:parameters][:distance]
      drag_force = roller_coaster_problem[:parameters][:drag_force]

      # Recalculate the answer for verification
      g = 9.81 # m/s^2
      expected_velocity = Math.sqrt(2 * ((g * height) - (drag_force * distance / mass)))

      expect(roller_coaster_problem[:answer]).to be_within(0.01).of(expected_velocity.round(2))
    end
  end

  describe '#generate_jam_production_cost_problem' do
    subject(:jam_problem) { test_class.generate_jam_production_cost_problem }

    it 'returns a hash' do
      expect(jam_problem).to be_a(Hash)
    end

    it 'sets the correct type' do
      expect(jam_problem[:type]).to eq('universal_account_equations')
    end

    it 'includes a question string' do
      expect(jam_problem[:question]).to be_a(String)
    end

    it 'includes a float answer' do
      expect(jam_problem[:answer]).to be_a(Float)
    end

    it 'includes input fields' do
      expect(jam_problem[:input_fields]).to be_a(Array)
    end

    it 'includes parameters' do
      expect(jam_problem[:parameters]).to be_a(Hash)
    end

    it 'includes necessary parameters' do
      params = jam_problem[:parameters]
      expect(params).to include(
        :blackberry_ratio, :sugar_ratio, :blackberry_water_percent,
        :blackberry_solids_percent, :sugar_solids_percent,
        :final_solids_percent, :blackberry_cost, :sugar_cost,
        :target_jam_mass
      )
    end
  end

  describe '#generate_fuel_efficiency_problem' do
    subject(:fuel_problem) { test_class.generate_fuel_efficiency_problem }

    it 'returns a hash' do
      expect(fuel_problem).to be_a(Hash)
    end

    it 'sets the correct type' do
      expect(fuel_problem[:type]).to eq('universal_account_equations')
    end

    it 'includes a question string' do
      expect(fuel_problem[:question]).to be_a(String)
    end

    it 'includes a numeric answer' do
      expect(fuel_problem[:answer]).to be_a(Numeric) # Use Numeric to match both Float and Integer
    end

    it 'includes input fields' do
      expect(fuel_problem[:input_fields]).to be_a(Array)
    end

    it 'includes parameters' do
      expect(fuel_problem[:parameters]).to be_a(Hash)
    end

    it 'includes necessary parameters' do
      params = fuel_problem[:parameters]
      expect(params).to include(:distance, :fuel_used, :fuel_cost)
    end
  end

  describe '#generate_mixing_solution_problem' do
    subject(:mixing_problem) { test_class.generate_mixing_solution_problem }

    it 'returns a hash' do
      expect(mixing_problem).to be_a(Hash)
    end

    it 'sets the correct type' do
      expect(mixing_problem[:type]).to eq('universal_account_equations')
    end

    it 'includes a question string' do
      expect(mixing_problem[:question]).to be_a(String)
    end

    it 'includes a float answer' do
      expect(mixing_problem[:answer]).to be_a(Float)
    end

    it 'includes input fields' do
      expect(mixing_problem[:input_fields]).to be_a(Array)
    end

    it 'includes parameters' do
      expect(mixing_problem[:parameters]).to be_a(Hash)
    end

    it 'includes necessary parameters' do
      params = mixing_problem[:parameters]
      expect(params).to include(
        :solution_a_volume, :solution_a_concentration,
        :solution_b_volume, :solution_b_concentration
      )
    end

    it 'calculates concentration correctly' do
      # Extract parameters for verification
      solution_a_volume = mixing_problem[:parameters][:solution_a_volume]
      solution_a_concentration = mixing_problem[:parameters][:solution_a_concentration]
      solution_b_volume = mixing_problem[:parameters][:solution_b_volume]
      solution_b_concentration = mixing_problem[:parameters][:solution_b_concentration]

      # Recalculate the answer for verification
      total_solute = (solution_a_volume * solution_a_concentration / 100.0) +
                     (solution_b_volume * solution_b_concentration / 100.0)
      total_volume = solution_a_volume + solution_b_volume
      expected_concentration = (total_solute / total_volume) * 100.0

      expect(mixing_problem[:answer]).to be_within(0.01).of(expected_concentration.round(2))
    end
  end

  describe '#generate_simple_interest_problem' do
    subject(:interest_problem) { test_class.generate_simple_interest_problem }

    it 'returns a hash' do
      expect(interest_problem).to be_a(Hash)
    end

    it 'sets the correct type' do
      expect(interest_problem[:type]).to eq('universal_account_equations')
    end

    it 'includes a question string' do
      expect(interest_problem[:question]).to be_a(String)
    end

    it 'includes a float answer' do
      expect(interest_problem[:answer]).to be_a(Float)
    end

    it 'includes input fields' do
      expect(interest_problem[:input_fields]).to be_a(Array)
    end

    it 'includes parameters' do
      expect(interest_problem[:parameters]).to be_a(Hash)
    end

    it 'includes necessary parameters' do
      params = interest_problem[:parameters]
      expect(params).to include(:principal, :rate, :time)
    end
  end

  describe '#generate_electricity_bill_problem' do
    subject(:electricity_problem) { test_class.generate_electricity_bill_problem }

    it 'returns a hash' do
      expect(electricity_problem).to be_a(Hash)
    end

    it 'sets the correct type' do
      expect(electricity_problem[:type]).to eq('universal_account_equations')
    end

    it 'includes a question string' do
      expect(electricity_problem[:question]).to be_a(String)
    end

    it 'includes a float answer' do
      expect(electricity_problem[:answer]).to be_a(Float)
    end

    it 'includes input fields' do
      expect(electricity_problem[:input_fields]).to be_a(Array)
    end

    it 'includes parameters' do
      expect(electricity_problem[:parameters]).to be_a(Hash)
    end

    it 'includes necessary parameters' do
      params = electricity_problem[:parameters]
      expect(params).to include(:power_rating, :hours_per_day, :days, :cost_per_kwh)
    end
  end

  describe '#generate_weight_conversion_problem' do
    subject(:weight_problem) { test_class.generate_weight_conversion_problem }

    it 'returns a hash' do
      expect(weight_problem).to be_a(Hash)
    end

    it 'sets the correct type' do
      expect(weight_problem[:type]).to eq('universal_account_equations')
    end

    it 'includes a question string' do
      expect(weight_problem[:question]).to be_a(String)
    end

    it 'includes a float answer' do
      expect(weight_problem[:answer]).to be_a(Float)
    end

    it 'includes input fields' do
      expect(weight_problem[:input_fields]).to be_a(Array)
    end

    it 'includes parameters' do
      expect(weight_problem[:parameters]).to be_a(Hash)
    end

    it 'includes necessary parameters' do
      params = weight_problem[:parameters]
      expect(params).to include(
        :num_items, :weight_per_item, :shipping_cost_per_kg,
        :packaging_weight_percent, :fragile_item_multiplier, :fragile_items_percent
      )
    end
  end
end
