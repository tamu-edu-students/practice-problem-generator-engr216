# Module containing all UAE question text formatting methods
module UniversalAccountEquationsQuestionText
  # Common instructions for all UAE problems
  def rounding_instructions
    "\n\nRound your answer to two (2) decimal places. Do not include units. " \
      'Do not use scientific notation.'
  end

  def roller_coaster_velocity_question_text(mass, height, distance, drag_force)
    "A roller coaster with mass #{mass} kg starts from rest at the top of a hill with a height of #{height} meters " \
      "and travels a total distance of #{distance} m to the bottom. " \
      "If the air resistance (drag force) is #{drag_force} N, " \
      "what is the final velocity of the roller coaster car at the bottom? #{rounding_instructions}"
  end

  def jam_production_cost_question_text(blackberry_ratio, sugar_ratio, blackberry_water_percent,
                                        blackberry_solids_percent, sugar_solids_percent,
                                        final_solids_percent, blackberry_cost, sugar_cost,
                                        target_jam_mass)
    "Blackberries and sugar are combined in a #{blackberry_ratio}:#{sugar_ratio} mass ratio to make jam. " \
      "Blackberries are #{blackberry_water_percent}% water and #{blackberry_solids_percent}% solids, " \
      "while sugar is #{sugar_solids_percent}% solids, and the mixture is heated to remove water " \
      "until the final solids content is #{final_solids_percent}%. " \
      "If blackberries cost $#{blackberry_cost}/kg and sugar costs $#{sugar_cost}/kg, " \
      "what is the cost of the blackberries in $ required to make #{target_jam_mass} kg of jam?" \
      "#{rounding_instructions}"
  end

  def fuel_efficiency_question_text(distance, fuel_used, fuel_cost, wind_resistance, vehicle_mass, rolling_resistance)
    "A vehicle with mass #{vehicle_mass} kg travels #{distance} km using #{fuel_used} liters of fuel. " \
      "The vehicle experiences a wind resistance of #{wind_resistance} N " \
      "and has a rolling resistance coefficient of #{rolling_resistance}. " \
      "The fuel costs $#{fuel_cost} per liter. " \
      "What is the cost per kilometer of fuel for this trip? #{rounding_instructions}"
  end

  def mixing_solution_question_text(solution_a_volume, solution_a_concentration,
                                    solution_b_volume, solution_b_concentration,
                                    evaporation_rate, temperature, mixing_time)
    "A laboratory technician mixes #{solution_a_volume} mL of a #{solution_a_concentration}% salt solution " \
      "with #{solution_b_volume} mL of a #{solution_b_concentration}% salt solution at #{temperature}°C. " \
      "During the #{mixing_time}-minute mixing process, #{evaporation_rate}% of the total volume evaporates. " \
      'Calculate the concentration (in %) of the resulting mixture.' \
      "#{rounding_instructions}"
  end

  def simple_interest_question_text(principal, rate, time, inflation_rate, tax_rate, compounding_frequency)
    "A bank account with an initial deposit of $#{principal} earns simple interest at a rate of #{rate}% per year, " \
      "compounded #{compounding_frequency} times per year. The interest is taxed at #{tax_rate}%, " \
      "and the inflation rate is #{inflation_rate}% per year. " \
      "Calculate the real value of the interest earned in $ after #{time} years, " \
      'accounting for both taxes and inflation.' \
      "#{rounding_instructions}"
  end

  def electricity_bill_question_text(power_rating, hours_per_day, days, cost_per_kwh,
                                     efficiency_factor, peak_hour_multiplier, peak_hours_per_day)
    "An appliance with a power rating of #{power_rating} watts " \
      "and an efficiency of #{(efficiency_factor * 100).to_i}% " \
      "is used for #{hours_per_day} hours per day for #{days} days. " \
      "During #{peak_hours_per_day} hours each day (peak hours), electricity costs $#{cost_per_kwh} per kWh " \
      "multiplied by #{peak_hour_multiplier}. For the remaining hours, electricity costs $#{cost_per_kwh} per kWh. " \
      "Calculate the total electricity bill in dollars. #{rounding_instructions}"
  end

  def weight_conversion_question_text(num_items, weight_per_item, shipping_cost_per_kg,
                                      packaging_weight_percent, fragile_item_multiplier, fragile_items_percent)
    "A shipment contains #{num_items} identical items, each weighing #{weight_per_item} grams. " \
      "The packaging adds #{packaging_weight_percent}% to the total weight. " \
      "#{fragile_items_percent}% of the items are fragile and require special handling, " \
      "increasing their shipping cost by a factor of #{fragile_item_multiplier}. " \
      "If shipping costs $#{shipping_cost_per_kg} per kilogram, calculate the total shipping cost in $." \
      "#{rounding_instructions}"
  end
end
