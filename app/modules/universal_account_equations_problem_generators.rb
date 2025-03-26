# Module containing all UAE problem generators
module UniversalAccountEquationsProblemGenerators
  # Create the basic structure for all UAE problems
  def build_uae_problem(question_text, answer, params = {})
    {
      type: 'universal_account_equations',
      question: question_text,
      answer: answer.round(2),
      input_fields: input_field_data,
      parameters: params
    }
  end

  def input_field_data
    [
      { label: 'Answer', key: 'answer' }
    ]
  end

  def generate_roller_coaster_velocity_problem
    # Generate random parameters within reasonable ranges
    mass = rand(1500..3000) # kg
    height = rand(20..50) # meters
    distance = rand(40..100) # meters
    g = 9.81 # m/s^2

    # Ensure drag_force is low enough to get a positive value under the square root
    # mgh = 0.5mv^2 + Fd
    # We need: gh - Fd/m > 0
    # so Fd/m < gh
    # or F < mgh/d
    max_drag = (mass * g * height / distance) * 0.9 # 90% of theoretical max
    drag_force = rand(1000..max_drag.to_i) # N

    # Calculate velocity using conservation of energy and work-energy principle
    # Initial potential energy = Final kinetic energy + Work done by drag force
    # mgh = 0.5mv^2 + Fd
    # v = sqrt(2(gh - Fd/m))
    velocity_squared = 2 * ((g * height) - (drag_force * distance / mass))
    # Ensure value is positive as a safeguard
    velocity_squared = [velocity_squared, 0.01].max
    velocity = Math.sqrt(velocity_squared)

    question_text = roller_coaster_velocity_question_text(mass, height, distance, drag_force)
    build_uae_problem(question_text, velocity, {
                        mass: mass,
                        height: height,
                        distance: distance,
                        drag_force: drag_force
                      })
  end

  def generate_jam_production_cost_problem
    # Generate random parameters within reasonable ranges
    blackberry_ratio = rand(50..70)
    sugar_ratio = 100 - blackberry_ratio
    blackberry_water_percent = rand(65..75)
    blackberry_solids_percent = 100 - blackberry_water_percent
    sugar_solids_percent = 100
    final_solids_percent = rand(70..80)
    blackberry_cost = rand(1.0..2.0).round(2)
    sugar_cost = rand(0.1..0.3).round(2)
    target_jam_mass = rand(0.5..2.0).round(1)

    # Calculate the cost of blackberries required
    x = (target_jam_mass * blackberry_ratio) / 100.0
    blackberry_cost_total = x * blackberry_cost

    question_text = jam_production_cost_question_text(
      blackberry_ratio, sugar_ratio, blackberry_water_percent,
      blackberry_solids_percent, sugar_solids_percent,
      final_solids_percent, blackberry_cost, sugar_cost,
      target_jam_mass
    )
    build_uae_problem(question_text, blackberry_cost_total, {
                        blackberry_ratio: blackberry_ratio,
                        sugar_ratio: sugar_ratio,
                        blackberry_water_percent: blackberry_water_percent,
                        blackberry_solids_percent: blackberry_solids_percent,
                        sugar_solids_percent: sugar_solids_percent,
                        final_solids_percent: final_solids_percent,
                        blackberry_cost: blackberry_cost,
                        sugar_cost: sugar_cost,
                        target_jam_mass: target_jam_mass
                      })
  end

  def generate_fuel_efficiency_problem
    # Generate random parameters
    distance = rand(200..500) # km
    fuel_used = rand(15..35) # L
    fuel_cost = rand(3.0..5.0).round(2) # $/L
    wind_resistance = rand(300..700) # N
    vehicle_mass = rand(1000..2500) # kg
    rolling_resistance = rand(0.01..0.03).round(3)

    # Calculate fuel efficiency and cost
    efficiency = distance / fuel_used # km/L # $

    question_text = fuel_efficiency_question_text(
      distance,
      fuel_used,
      fuel_cost,
      wind_resistance,
      vehicle_mass,
      rolling_resistance
    )
    build_uae_problem(question_text, efficiency, {
                        distance: distance,
                        fuel_used: fuel_used,
                        fuel_cost: fuel_cost,
                        wind_resistance: wind_resistance,
                        vehicle_mass: vehicle_mass,
                        rolling_resistance: rolling_resistance
                      })
  end

  def generate_mixing_solution_problem
    # Generate random parameters
    solution_a_volume = rand(100..300) # mL
    solution_a_concentration = rand(5..15) # %
    solution_b_volume = rand(100..300) # mL
    solution_b_concentration = rand(20..40) # %
    evaporation_rate = rand(1..5) # % of volume that evaporates
    temperature = rand(20..40) # °C
    mixing_time = rand(5..20) # minutes

    # Calculate final concentration
    total_solute = (solution_a_volume * solution_a_concentration / 100.0) +
                   (solution_b_volume * solution_b_concentration / 100.0)
    total_volume = solution_a_volume + solution_b_volume
    final_concentration = (total_solute / total_volume) * 100.0

    question_text = mixing_solution_question_text(
      solution_a_volume,
      solution_a_concentration,
      solution_b_volume,
      solution_b_concentration,
      evaporation_rate,
      temperature,
      mixing_time
    )
    build_uae_problem(question_text, final_concentration, {
                        solution_a_volume: solution_a_volume,
                        solution_a_concentration: solution_a_concentration,
                        solution_b_volume: solution_b_volume,
                        solution_b_concentration: solution_b_concentration,
                        evaporation_rate: evaporation_rate,
                        temperature: temperature,
                        mixing_time: mixing_time
                      })
  end

  def generate_simple_interest_problem
    # Generate random parameters
    principal = rand(1000..5000) # $
    rate = rand(3..7).to_f / 100 # annual rate as decimal
    time = rand(1..5) # years
    inflation_rate = rand(1..3).to_f / 100 # annual inflation rate as decimal
    tax_rate = rand(10..25) # tax rate in %
    compounding_frequency = %w[monthly quarterly annually].sample

    # Calculate simple interest
    interest = principal * rate * time

    question_text = simple_interest_question_text(
      principal,
      rate * 100,
      time,
      inflation_rate * 100,
      tax_rate,
      compounding_frequency
    )
    build_uae_problem(question_text, interest, {
                        principal: principal,
                        rate: rate,
                        time: time,
                        inflation_rate: inflation_rate,
                        tax_rate: tax_rate,
                        compounding_frequency: compounding_frequency
                      })
  end

  def generate_electricity_bill_problem
    # Generate random parameters
    power_rating = rand(1000..3000) # watts
    hours_per_day = rand(3..8) # hours
    days = rand(20..30) # days
    cost_per_kwh = rand(0.10..0.25).round(2) # $/kWh
    efficiency_factor = rand(0.85..0.95) # efficiency as decimal
    peak_hour_multiplier = rand(1.2..1.5).round(1) # price multiplier for peak hours
    peak_hours_per_day = rand(2..4) # hours per day that are peak hours

    # Calculate electricity cost
    total_kwh = (power_rating * hours_per_day * days) / 1000.0 # convert to kWh
    total_cost = total_kwh * cost_per_kwh

    question_text = electricity_bill_question_text(
      power_rating,
      hours_per_day,
      days,
      cost_per_kwh,
      efficiency_factor,
      peak_hour_multiplier,
      peak_hours_per_day
    )
    build_uae_problem(question_text, total_cost, {
                        power_rating: power_rating,
                        hours_per_day: hours_per_day,
                        days: days,
                        cost_per_kwh: cost_per_kwh,
                        efficiency_factor: efficiency_factor,
                        peak_hour_multiplier: peak_hour_multiplier,
                        peak_hours_per_day: peak_hours_per_day
                      })
  end

  def generate_weight_conversion_problem
    # Generate random parameters
    num_items = rand(30..100) # items
    weight_per_item = rand(50..200) # grams
    shipping_cost_per_kg = rand(5..15) # $/kg
    packaging_weight_percent = rand(5..15) # %
    fragile_item_multiplier = rand(1.2..1.5).round(2) # multiplier
    fragile_items_percent = rand(20..40) # %

    # Calculate total shipping cost
    total_weight_kg = (num_items * weight_per_item) / 1000.0 # convert to kg
    packaging_weight = total_weight_kg * (packaging_weight_percent / 100.0)
    fragile_items = num_items * (fragile_items_percent / 100.0)
    regular_items = num_items - fragile_items

    regular_cost = (regular_items * weight_per_item / 1000.0) * shipping_cost_per_kg
    fragile_cost = (fragile_items * weight_per_item / 1000.0) * shipping_cost_per_kg * fragile_item_multiplier
    packaging_cost = packaging_weight * shipping_cost_per_kg

    total_cost = regular_cost + fragile_cost + packaging_cost

    question_text = weight_conversion_question_text(
      num_items, weight_per_item, shipping_cost_per_kg,
      packaging_weight_percent, fragile_item_multiplier, fragile_items_percent
    )
    build_uae_problem(question_text, total_cost, {
                        num_items: num_items,
                        weight_per_item: weight_per_item,
                        shipping_cost_per_kg: shipping_cost_per_kg,
                        packaging_weight_percent: packaging_weight_percent,
                        fragile_item_multiplier: fragile_item_multiplier,
                        fragile_items_percent: fragile_items_percent
                      })
  end
end
