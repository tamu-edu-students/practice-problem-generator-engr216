# This class generates confidence interval problems for students
class ConfidenceIntervalProblemGenerator
  # Include the extracted modules
  include ConfidenceIntervalQuestionText
  include ConfidenceIntervalProblemGenerators

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
      parameters: extract_parameters(params)
    }
  end

  def extract_parameters(params)
    {
      sample_size: params[:sample_size],
      sample_mean: params[:sample_mean],
      pop_std: params[:pop_std],
      confidence_level: params[:confidence_level]
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
end
