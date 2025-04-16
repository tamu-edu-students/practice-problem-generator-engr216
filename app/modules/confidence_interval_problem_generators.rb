# Module containing all confidence interval problem generators
module ConfidenceIntervalProblemGenerators
  def generate_battery_lifetime_problem
    params = generate_common_parameters(950..1050, 120..220)
    lower_bound, upper_bound = calculate_bounds(params)
    question = battery_question_text(*params.values)
    build_confidence_interval_problem(question, lower_bound, upper_bound, 1, params)
  end

  def generate_cereal_box_fill_problem
    params = generate_common_parameters(495..505, 5..15)
    lower_bound, upper_bound = calculate_bounds(params)
    question = cereal_question_text(*params.values)
    build_confidence_interval_problem(question, lower_bound, upper_bound, 2, params)
  end

  def generate_waiting_times_problem
    params = generate_common_parameters(120..250, 30..60, 40..120)
    lower_bound, upper_bound = calculate_bounds(params)
    question = waiting_times_question_text(*params.values)
    build_confidence_interval_problem(question, lower_bound, upper_bound, 3, params)
  end

  def generate_car_mileage_problem
    params = generate_common_parameters(220..320, 30..50)
    lower_bound, upper_bound = calculate_bounds(params)
    question = car_mileage_question_text(*params.values)
    build_confidence_interval_problem(question, lower_bound, upper_bound, 4, params)
  end

  def generate_produce_weight_problem
    params = generate_common_parameters(150..250, 20..40)
    lower_bound, upper_bound = calculate_bounds(params)
    question = produce_weight_question_text(*params.values)
    build_confidence_interval_problem(question, lower_bound, upper_bound, 5, params)
  end

  def generate_shipping_times_problem
    params = generate_common_parameters(24..72, 5..15)
    lower_bound, upper_bound = calculate_bounds(params)
    question = shipping_times_question_text(*params.values)
    build_confidence_interval_problem(question, lower_bound, upper_bound, 6, params)
  end

  def generate_manufacturing_diameter_problem
    params = generate_common_parameters(45..55, 2..10, 30..80)
    lower_bound, upper_bound = calculate_bounds(params)
    question = manufacturing_diameter_question_text(*params.values)
    build_confidence_interval_problem(question, lower_bound, upper_bound, 7, params)
  end

  def generate_concentration_problem
    params = generate_common_parameters(10..100, 2..8)
    lower_bound, upper_bound = calculate_bounds(params)
    question = concentration_question_text(*params.values)
    build_confidence_interval_problem(question, lower_bound, upper_bound, 8, params)
  end

  def generate_phone_call_duration_problem
    params = generate_common_parameters(150..450, 30..90)
    lower_bound, upper_bound = calculate_bounds(params)
    question = phone_call_duration_question_text(*params.values)
    build_confidence_interval_problem(question, lower_bound, upper_bound, 9, params)
  end

  def generate_daily_water_usage_problem
    params = generate_common_parameters(200..400, 40..80)
    lower_bound, upper_bound = calculate_bounds(params)
    question = daily_water_usage_question_text(*params.values)
    build_confidence_interval_problem(question, lower_bound, upper_bound, 10, params)
  end
end
