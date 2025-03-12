# This class generates confidence interval problems for students
class ConfidenceIntervalProblemGenerator
  def initialize(category)
    @category = category
  end

  # Generate a single confidence interval problem
  def generate_questions
    [generate_confidence_interval_problem]
  end

  private

  # Generate a random confidence interval problem
  def generate_confidence_interval_problem
    generators = %i[
      battery_lifetime cereal_box_fill waiting_times
      car_mileage produce_weight shipping_times
      manufacturing_diameter concentration
      phone_call_duration daily_water_usage
    ]

    send(:"generate_#{generators.sample}_problem")
  end

  # Calculate confidence interval based on statistical parameters
  def calculate_confidence_interval(sample_mean, pop_std, sample_size, confidence_level)
    # Use a simple mapping for z-values
    z_value = confidence_z_value(confidence_level)

    # Calculate margin of error
    margin_error = z_value * (pop_std / Math.sqrt(sample_size))

    # Calculate and return bounds
    [sample_mean - margin_error, sample_mean + margin_error]
  end

  # Map confidence levels to z-values
  def confidence_z_value(confidence_level)
    z_values = {
      90 => 1.645,
      95 => 1.96,
      98 => 2.33,
      99 => 2.575
    }

    z_values.fetch(confidence_level, 1.96) # Default to 1.96 if not specified
  end

  # Common instructions for all confidence interval problems
  def rounding_instructions
    "\n\nRound your answer to two (2) decimal places. Do not include units. " \
      'Do not use scientific notation.'
  end

  # Create the basic structure for all confidence interval problems
  def build_confidence_interval_problem(question_text, lower_bound, upper_bound, params = {})
    {
      type: 'confidence_interval',
      question: question_text,
      answers: answer_data(lower_bound, upper_bound),
      input_fields: input_field_data,
      parameters: {
        sample_size: params[:sample_size],
        sample_mean: params[:sample_mean],
        pop_std: params[:pop_std],
        confidence_level: params[:confidence_level]
      }
    }
  end

  def answer_data(lower_bound, upper_bound)
    {
      lower_bound: lower_bound.round(2),
      upper_bound: upper_bound.round(2)
    }
  end

  def input_field_data
    [
      { label: 'Lower Bound', key: 'lower_bound' },
      { label: 'Upper Bound', key: 'upper_bound' }
    ]
  end

  # Problem generators for different scenarios
  def generate_battery_lifetime_problem
    params = generate_common_parameters(950..1050, 120..220)
    lower_bound, upper_bound = calculate_bounds(params)
    question = battery_question_text(*params.values)
    build_confidence_interval_problem(question, lower_bound, upper_bound, params)
  end

  def battery_question_text(sample_size, sample_mean, pop_std, confidence_level)
    "A company tests #{sample_size} randomly selected batteries " \
      "and finds that the mean lifetime is #{sample_mean.round(1)} hours. " \
      "Assume the population standard deviation is #{pop_std.round(1)} hours, " \
      'and the lifetimes are approximately normally distributed. ' \
      "Construct a #{confidence_level}% confidence interval for the true mean " \
      'battery lifetime. Provide the lower bound and the upper bound.' \
      "#{rounding_instructions}"
  end

  # Additional problem generators with similar structure
  def generate_cereal_box_fill_problem
    params = generate_common_parameters(495..505, 5..15)
    lower_bound, upper_bound = calculate_bounds(params)
    question = cereal_question_text(*params.values)
    build_confidence_interval_problem(question, lower_bound, upper_bound, params)
  end

  def cereal_question_text(sample_size, sample_mean, pop_std, confidence_level)
    "A quality control team measures the amount of cereal in #{sample_size} boxes. " \
      "The sample has a mean fill of #{sample_mean.round(1)} grams. " \
      "Assume the population standard deviation is #{pop_std.round(1)} grams, " \
      'and the fill amounts follow a normal distribution. ' \
      "Construct a #{confidence_level}% confidence interval for the true mean " \
      'fill of cereal boxes. Provide the lower bound and the upper bound.' \
      "#{rounding_instructions}"
  end

  # Implement similar pattern for other problem generators
  # Each generator follows the pattern:
  # 1. Set up parameters
  # 2. Calculate confidence interval
  # 3. Format question text using helper method
  # 4. Build and return problem

  # Only showing a few more examples - the rest would follow the same pattern

  def generate_waiting_times_problem
    params = generate_common_parameters(120..250, 30..60, 40..120)
    lower_bound, upper_bound = calculate_bounds(params)
    question = waiting_times_question_text(*params.values)
    build_confidence_interval_problem(question, lower_bound, upper_bound, params)
  end

  def waiting_times_question_text(sample_size, sample_mean, pop_std, confidence_level)
    "A hospital records wait times for #{sample_size} emergency room patients, " \
      "with a mean wait time of #{sample_mean.round(1)} minutes. " \
      "Assuming a population standard deviation of #{pop_std.round(1)} minutes " \
      'and that wait times are normally distributed, ' \
      "construct a #{confidence_level}% confidence interval for the true mean wait time. " \
      "Provide the lower bound and the upper bound.#{rounding_instructions}"
  end

  # Helper methods to reduce duplication and method length
  def generate_common_parameters(mean_range, std_range, size_range = 30..100)
    {
      sample_size: rand(size_range),
      sample_mean: rand(mean_range) / 10.0,
      pop_std: rand(std_range) / 10.0,
      confidence_level: [90, 95, 99].sample
    }
  end

  def calculate_bounds(params)
    calculate_confidence_interval(
      params[:sample_mean], params[:pop_std],
      params[:sample_size], params[:confidence_level]
    )
  end

  # Additional problem generators (car_mileage, produce_weight, etc.)
  def generate_car_mileage_problem
    params = generate_common_parameters(220..320, 30..50)
    lower_bound, upper_bound = calculate_bounds(params)
    question = car_mileage_question_text(*params.values)
    build_confidence_interval_problem(question, lower_bound, upper_bound, params)
  end

  def car_mileage_question_text(sample_size, sample_mean, pop_std, confidence_level)
    "A random sample of #{sample_size} cars is tested for fuel efficiency. " \
      "The sample shows an average of #{sample_mean.round(1)} miles per gallon. " \
      "Assume the population standard deviation is #{pop_std.round(1)} miles per gallon " \
      'and that the data are approximately normally distributed. ' \
      "Construct a #{confidence_level}% confidence interval for the true mean fuel efficiency. " \
      "Provide the lower bound and the upper bound.#{rounding_instructions}"
  end

  def generate_produce_weight_problem
    params = generate_common_parameters(150..250, 20..40)
    lower_bound, upper_bound = calculate_bounds(params)
    question = produce_weight_question_text(*params.values)
    build_confidence_interval_problem(question, lower_bound, upper_bound, params)
  end

  def produce_weight_question_text(sample_size, sample_mean, pop_std, confidence_level)
    "A grocery store weighs #{sample_size} pieces of produce, " \
      "finding an average weight of #{sample_mean.round(1)} grams. " \
      "The population standard deviation is #{pop_std.round(1)} grams, " \
      'and the weight is assumed to follow a normal distribution. ' \
      "Construct a #{confidence_level}% confidence interval for the true mean weight. " \
      "Provide the lower bound and the upper bound.#{rounding_instructions}"
  end

  def generate_shipping_times_problem
    params = generate_common_parameters(24..72, 5..15)
    lower_bound, upper_bound = calculate_bounds(params)
    question = shipping_times_question_text(*params.values)
    build_confidence_interval_problem(question, lower_bound, upper_bound, params)
  end

  def shipping_times_question_text(sample_size, sample_mean, pop_std, confidence_level)
    "A shipping company monitors #{sample_size} shipments and finds " \
      "the mean delivery time to be #{sample_mean.round(1)} hours. " \
      "Assume the population standard deviation is #{pop_std.round(1)}, " \
      'and delivery times follow a normal distribution. ' \
      "Construct a #{confidence_level}% confidence interval for the true mean delivery time. " \
      "Provide the lower bound and the upper bound.#{rounding_instructions}"
  end

  def generate_manufacturing_diameter_problem
    params = generate_common_parameters(45..55, 2..10, 30..80)
    lower_bound, upper_bound = calculate_bounds(params)
    question = manufacturing_diameter_question_text(*params.values)
    build_confidence_interval_problem(question, lower_bound, upper_bound, params)
  end

  def manufacturing_diameter_question_text(sample_size, sample_mean, pop_std, confidence_level)
    "A factory measures the diameter of #{sample_size} parts, " \
      "obtaining a sample mean diameter of #{sample_mean.round(1)} mm. " \
      "The population standard deviation is #{pop_std.round(1)} mm, " \
      'and the diameters are approximately normally distributed. ' \
      "Construct a #{confidence_level}% confidence interval for the true mean diameter. " \
      "Provide the lower bound and the upper bound.#{rounding_instructions}"
  end

  def generate_concentration_problem
    params = generate_common_parameters(10..100, 2..8)
    lower_bound, upper_bound = calculate_bounds(params)
    question = concentration_question_text(*params.values)
    build_confidence_interval_problem(question, lower_bound, upper_bound, params)
  end

  def concentration_question_text(sample_size, sample_mean, pop_std, confidence_level)
    "In an environmental study, #{sample_size} water samples are tested, " \
      "yielding a mean concentration of #{sample_mean.round(1)} ppm. " \
      "Assume the population standard deviation is #{pop_std.round(1)} ppm, " \
      'and concentrations follow a normal distribution. ' \
      "Construct a #{confidence_level}% confidence interval for the true mean concentration. " \
      "Provide the lower bound and the upper bound.#{rounding_instructions}"
  end

  def generate_phone_call_duration_problem
    params = generate_common_parameters(150..450, 30..90)
    lower_bound, upper_bound = calculate_bounds(params)
    question = phone_call_duration_question_text(*params.values)
    build_confidence_interval_problem(question, lower_bound, upper_bound, params)
  end

  def phone_call_duration_question_text(sample_size, sample_mean, pop_std, confidence_level)
    "A telecom company records #{sample_size} phone calls, " \
      "finding a mean call duration of #{sample_mean.round(1)} seconds. " \
      "The population standard deviation is #{pop_std.round(1)} seconds, " \
      'and durations are assumed to be normally distributed. ' \
      "Construct a #{confidence_level}% confidence interval for the true mean call duration. " \
      "Provide the lower bound and the upper bound.#{rounding_instructions}"
  end

  def generate_daily_water_usage_problem
    params = generate_common_parameters(200..400, 40..80)
    lower_bound, upper_bound = calculate_bounds(params)
    question = daily_water_usage_question_text(*params.values)
    build_confidence_interval_problem(question, lower_bound, upper_bound, params)
  end

  def daily_water_usage_question_text(sample_size, sample_mean, pop_std, confidence_level)
    "A city measures the daily water usage of #{sample_size} households, " \
      "with a sample mean usage of #{sample_mean.round(1)} gallons. " \
      "Assume the population standard deviation is #{pop_std.round(1)} gallons, " \
      'and water usage is normally distributed. ' \
      "Construct a #{confidence_level}% confidence interval for the true mean daily water usage. " \
      "Provide the lower bound and the upper bound.#{rounding_instructions}"
  end
end
