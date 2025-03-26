require 'rails_helper'

RSpec.describe UniversalAccountEquationsQuestionText do
  # Create a test class that includes the module
  let(:test_class) do
    Class.new do
      include UniversalAccountEquationsQuestionText
    end.new
  end

  describe '#rounding_instructions' do
    subject(:instructions) { test_class.rounding_instructions }

    it 'returns a string' do
      expect(instructions).to be_a(String)
    end

    it 'includes instructions about decimal places' do
      expect(instructions).to include('Round your answer to two (2) decimal places')
    end

    it 'includes instructions about units' do
      expect(instructions).to include('Do not include units')
    end

    it 'includes instructions about scientific notation' do
      expect(instructions).to include('Do not use scientific notation')
    end
  end

  describe '#roller_coaster_velocity_question_text' do
    subject(:question_text) { test_class.roller_coaster_velocity_question_text(mass, height, distance, drag_force) }

    let(:mass) { 2000 }
    let(:height) { 30 }
    let(:distance) { 60 }
    let(:drag_force) { 5000 }

    it 'includes the mass parameter' do
      expect(question_text).to include("mass #{mass} kg")
    end

    it 'includes the height parameter' do
      expect(question_text).to include("height of #{height} meters")
    end

    it 'includes the distance parameter' do
      expect(question_text).to include("distance of #{distance} m")
    end

    it 'includes the drag force parameter' do
      expect(question_text).to include("drag force) is #{drag_force} N")
    end

    it 'includes rounding instructions' do
      expect(question_text).to include(test_class.rounding_instructions)
    end
  end

  describe '#jam_production_cost_question_text' do
    subject(:jam_question) do
      test_class.jam_production_cost_question_text(
        blackberry_ratio, sugar_ratio, blackberry_water_percent,
        blackberry_solids_percent, sugar_solids_percent,
        final_solids_percent, blackberry_cost, sugar_cost,
        target_jam_mass
      )
    end

    let(:blackberry_ratio) { 3 }
    let(:sugar_ratio) { 1 }
    let(:blackberry_water_percent) { 80 }
    let(:blackberry_solids_percent) { 20 }
    let(:sugar_solids_percent) { 100 }
    let(:final_solids_percent) { 65 }
    let(:blackberry_cost) { 5.50 }
    let(:sugar_cost) { 2.25 }
    let(:target_jam_mass) { 10 }

    it 'includes the mass ratio' do
      expect(jam_question).to include("#{blackberry_ratio}:#{sugar_ratio} mass ratio")
    end

    it 'includes the blackberry water percentage' do
      expect(jam_question).to include("#{blackberry_water_percent}% water")
    end

    it 'includes the blackberry solids percentage' do
      expect(jam_question).to include("#{blackberry_solids_percent}% solids")
    end

    it 'includes the sugar solids percentage' do
      expect(jam_question).to include("#{sugar_solids_percent}% solids")
    end

    it 'includes the final solids percentage' do
      expect(jam_question).to include("#{final_solids_percent}%")
    end

    it 'includes the blackberry cost' do
      expect(jam_question).to include("$#{blackberry_cost}/kg")
    end

    it 'includes the sugar cost' do
      expect(jam_question).to include("$#{sugar_cost}/kg")
    end

    it 'includes the target jam mass' do
      expect(jam_question).to include("#{target_jam_mass} kg of jam")
    end

    it 'includes rounding instructions' do
      expect(jam_question).to include(test_class.rounding_instructions)
    end
  end

  describe '#fuel_efficiency_question_text' do
    subject(:fuel_question) do
      test_class.fuel_efficiency_question_text(
        distance, fuel_used, fuel_cost, wind_resistance, vehicle_mass, rolling_resistance
      )
    end

    let(:distance) { 500 }
    let(:fuel_used) { 30 }
    let(:fuel_cost) { 3.50 }
    let(:wind_resistance) { 800 }
    let(:vehicle_mass) { 1500 }
    let(:rolling_resistance) { 0.015 }

    it 'includes the vehicle mass' do
      expect(fuel_question).to include("mass #{vehicle_mass} kg")
    end

    it 'includes the distance' do
      expect(fuel_question).to include("#{distance} km")
    end

    it 'includes the fuel used' do
      expect(fuel_question).to include("#{fuel_used} liters")
    end

    it 'includes the wind resistance' do
      expect(fuel_question).to include("wind resistance of #{wind_resistance} N")
    end

    it 'includes the rolling resistance coefficient' do
      expect(fuel_question).to include("rolling resistance coefficient of #{rolling_resistance}")
    end

    it 'includes the fuel cost' do
      expect(fuel_question).to include("$#{fuel_cost} per liter")
    end

    it 'includes rounding instructions' do
      expect(fuel_question).to include(test_class.rounding_instructions)
    end
  end

  describe '#mixing_solution_question_text' do
    subject(:mixing_question) do
      test_class.mixing_solution_question_text(
        solution_a_volume, solution_a_concentration,
        solution_b_volume, solution_b_concentration,
        evaporation_rate, temperature, mixing_time
      )
    end

    let(:solution_a_volume) { 200 }
    let(:solution_a_concentration) { 10 }
    let(:solution_b_volume) { 150 }
    let(:solution_b_concentration) { 25 }
    let(:evaporation_rate) { 5 }
    let(:temperature) { 25 }
    let(:mixing_time) { 30 }

    it 'includes solution A volume' do
      expect(mixing_question).to include("#{solution_a_volume} mL")
    end

    it 'includes solution A concentration' do
      expect(mixing_question).to include("#{solution_a_concentration}% salt solution")
    end

    it 'includes solution B volume' do
      expect(mixing_question).to include("#{solution_b_volume} mL")
    end

    it 'includes solution B concentration' do
      expect(mixing_question).to include("#{solution_b_concentration}% salt solution")
    end

    it 'includes temperature' do
      expect(mixing_question).to include("#{temperature}°C")
    end

    it 'includes mixing time' do
      expect(mixing_question).to include("#{mixing_time}-minute mixing process")
    end

    it 'includes evaporation rate' do
      expect(mixing_question).to include("#{evaporation_rate}% of the total volume")
    end

    it 'includes rounding instructions' do
      expect(mixing_question).to include(test_class.rounding_instructions)
    end
  end

  describe '#simple_interest_question_text' do
    subject(:interest_question) do
      test_class.simple_interest_question_text(
        principal, rate, time, inflation_rate, tax_rate, compounding_frequency
      )
    end

    let(:principal) { 2000 }
    let(:rate) { 5 }
    let(:time) { 3 }
    let(:inflation_rate) { 2 }
    let(:tax_rate) { 20 }
    let(:compounding_frequency) { 4 }

    it 'includes the principal amount' do
      expect(interest_question).to include("$#{principal}")
    end

    it 'includes the interest rate' do
      expect(interest_question).to include("#{rate}% per year")
    end

    it 'includes the compounding frequency' do
      expect(interest_question).to include("compounded #{compounding_frequency} times per year")
    end

    it 'includes the tax rate' do
      expect(interest_question).to include("taxed at #{tax_rate}%")
    end

    it 'includes the inflation rate' do
      expect(interest_question).to include("inflation rate is #{inflation_rate}% per year")
    end

    it 'includes the time period' do
      expect(interest_question).to include("after #{time} years")
    end

    it 'includes rounding instructions' do
      expect(interest_question).to include(test_class.rounding_instructions)
    end
  end

  describe '#electricity_bill_question_text' do
    subject(:electricity_question) do
      test_class.electricity_bill_question_text(
        power_rating, hours_per_day, days, cost_per_kwh,
        efficiency_factor, peak_hour_multiplier, peak_hours_per_day
      )
    end

    let(:power_rating) { 1500 }
    let(:hours_per_day) { 6 }
    let(:days) { 25 }
    let(:cost_per_kwh) { 0.12 }
    let(:efficiency_factor) { 0.9 }
    let(:peak_hour_multiplier) { 1.5 }
    let(:peak_hours_per_day) { 3 }

    it 'includes the power rating' do
      expect(electricity_question).to include("power rating of #{power_rating} watts")
    end

    it 'includes the efficiency' do
      expect(electricity_question).to include("efficiency of #{(efficiency_factor * 100).to_i}%")
    end

    it 'includes hours per day' do
      expect(electricity_question).to include("#{hours_per_day} hours per day")
    end

    it 'includes the number of days' do
      expect(electricity_question).to include("#{days} days")
    end

    it 'includes peak hours' do
      expect(electricity_question).to include("During #{peak_hours_per_day} hours each day")
    end

    it 'includes cost per kWh' do
      expect(electricity_question).to include("$#{cost_per_kwh} per kWh")
    end

    it 'includes peak hour multiplier' do
      expect(electricity_question).to include("multiplied by #{peak_hour_multiplier}")
    end

    it 'includes rounding instructions' do
      expect(electricity_question).to include(test_class.rounding_instructions)
    end
  end

  describe '#weight_conversion_question_text' do
    subject(:weight_question) do
      test_class.weight_conversion_question_text(
        num_items, weight_per_item, shipping_cost_per_kg,
        packaging_weight_percent, fragile_item_multiplier, fragile_items_percent
      )
    end

    let(:num_items) { 50 }
    let(:weight_per_item) { 100 }
    let(:shipping_cost_per_kg) { 8 }
    let(:packaging_weight_percent) { 10 }
    let(:fragile_item_multiplier) { 1.3 }
    let(:fragile_items_percent) { 30 }

    it 'includes the number of items' do
      expect(weight_question).to include("#{num_items} identical items")
    end

    it 'includes the weight per item' do
      expect(weight_question).to include("#{weight_per_item} grams")
    end

    it 'includes the packaging weight percentage' do
      expect(weight_question).to include("#{packaging_weight_percent}% to the total weight")
    end

    it 'includes the fragile items percentage' do
      expect(weight_question).to include("#{fragile_items_percent}% of the items are fragile")
    end

    it 'includes the fragile item multiplier' do
      expect(weight_question).to include("factor of #{fragile_item_multiplier}")
    end

    it 'includes the shipping cost per kg' do
      expect(weight_question).to include("$#{shipping_cost_per_kg} per kilogram")
    end

    it 'includes rounding instructions' do
      expect(weight_question).to include(test_class.rounding_instructions)
    end
  end
end
