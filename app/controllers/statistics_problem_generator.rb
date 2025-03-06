class StatisticsProblemGenerator
  def initialize(category)
    @category = category
  end

  # generate both types of questions
  def generate_questions
    [generate_probability_problem, generate_data_statistics_problem]
  end

  private

  def generate_probability_problem
    send(%i[generate_machine_repair_problem generate_produce_weight_problem
            generate_assembly_line_problem generate_battery_lifespan_problem
            generate_customer_wait_time_problem generate_package_weight_problem
            generate_exam_score_problem generate_component_lifetime_problem
            generate_medication_dosage_problem].sample)
  end

  def answer_format_notes
    "\n\nYour answer should be a number between 0.0 and 100.0. Round your answer to two (2) decimal places. " \
      'Example: 99.44 Do not include units. Do not use scientific notation.'
  end

  def build_probability_problem(question_text, probability)
    {
      type: 'probability',
      question: question_text + answer_format_notes,
      answer: probability.round(2),
      input_fields: nil
    }
  end

  def upper_tail_probability(mean, std_dev, threshold)
    z_score = (threshold - mean) / std_dev
    (1 - StatisticsHelper.pnorm(z_score)) * 100
  end

  def lower_tail_probability(mean, std_dev, threshold)
    z_score = (threshold - mean) / std_dev
    StatisticsHelper.pnorm(z_score) * 100
  end

  def between_probability(mean, std_dev, lower_bound, upper_bound)
    lower_z = (lower_bound - mean) / std_dev
    upper_z = (upper_bound - mean) / std_dev
    (StatisticsHelper.pnorm(upper_z) - StatisticsHelper.pnorm(lower_z)) * 100
  end

  def generate_machine_repair_problem
    mean = rand(5.0..15.0).round(1)
    std_dev = rand(1.0..3.0).round(1)
    threshold = (mean + rand(-1.0..2.0)).round(1)

    probability = upper_tail_probability(mean, std_dev, threshold)

    question_text = "A machine in a packaging plant requires an average repair time of #{mean} hours " \
                    "with a standard deviation of #{std_dev} hours, assuming repair times follow a " \
                    'normal distribution. What is the probability that a repair will take longer ' \
                    "than #{threshold} hours?"

    build_probability_problem(question_text, probability)
  end

  def generate_produce_weight_problem
    mean = rand(150.0..500.0).round(1)
    sd = rand(10.0..50.0).round(1)
    lower_bound = (mean - rand(10.0..30.0)).round(1)
    upper_bound = (mean + rand(10.0..30.0)).round(1)

    probability = between_probability(mean, sd, lower_bound, upper_bound)

    question_text = "The weight of produce at a local market is normally distributed with a mean of #{mean} grams " \
                    "and a standard deviation of #{sd} grams. What is the probability that a randomly chosen piece " \
                    "of produce weighs between #{lower_bound} grams and #{upper_bound} grams?"

    build_probability_problem(question_text, probability)
  end

  def generate_assembly_line_problem
    mean = rand(50.0..200.0).round(1)
    sd = rand(5.0..20.0).round(1)
    threshold = (mean + rand(-10.0..10.0)).round(1)

    probability = upper_tail_probability(mean, sd, threshold)

    question_text = "An assembly line produces an average of #{mean} units per hour with a standard deviation " \
                    "of #{sd} units, assuming a normal distribution. What is the probability that the line " \
                    "produces at least #{threshold} units in one hour?"

    build_probability_problem(question_text, probability)
  end

  def generate_battery_lifespan_problem
    mean = rand(200.0..500.0).round(1)
    sd = rand(20.0..50.0).round(1)
    threshold = (mean + rand(-100.0..50.0)).round(1)

    probability = lower_tail_probability(mean, sd, threshold)

    question_text = "A certain type of battery has a mean lifetime of #{mean} days and a standard deviation " \
                    "of #{sd} days, assuming a normal distribution. What is the probability that a randomly " \
                    "selected battery will last less than #{threshold} days?"

    build_probability_problem(question_text, probability)
  end

  def generate_customer_wait_time_problem
    mean = rand(5.0..20.0).round(1)
    sd = rand(1.0..5.0).round(1)
    lower_bound = (mean - rand(1.0..5.0)).round(1)
    upper_bound = (mean + rand(1.0..5.0)).round(1)

    probability = between_probability(mean, sd, lower_bound, upper_bound)

    question_text = "A customer service center has an average wait time of #{mean} minutes and a standard deviation " \
                    "of #{sd} minutes. Assuming wait times are normally distributed, what is the probability " \
                    "that a customer waits between #{lower_bound} and #{upper_bound} minutes?"

    build_probability_problem(question_text, probability)
  end

  def generate_package_weight_problem
    mean = rand(2.0..10.0).round(1)
    sd = rand(0.2..1.0).round(1)
    threshold = (mean + rand(0.5..2.0)).round(1)

    probability = upper_tail_probability(mean, sd, threshold)

    question_text = 'Packages shipped by a company have weights that are normally distributed ' \
                    "with a mean of #{mean} kilograms and a standard deviation of #{sd} kilograms. " \
                    "What is the probability that a package weighs more than #{threshold} kilograms?"

    build_probability_problem(question_text, probability)
  end

  def generate_exam_score_problem
    mean = rand(65.0..80.0).round(1)
    sd = rand(5.0..15.0).round(1)
    pass_score = rand(mean - 10.0..mean + 10.0).round(1)

    probability = upper_tail_probability(mean, sd, pass_score)

    question_text = "Scores on a standardized exam are normally distributed with a mean of #{mean} points " \
                    "and a standard deviation of #{sd} points. If a passing score is #{pass_score}, " \
                    'what is the probability that a randomly selected test-taker will pass?'

    build_probability_problem(question_text, probability)
  end

  def generate_component_lifetime_problem
    mean = rand(5000.0..10_000.0).round(1)
    sd = rand(500.0..1000.0).round(1)
    lower_bound = (mean - rand(1000.0..2000.0)).round(1)
    upper_bound = (mean + rand(1000.0..2000.0)).round(1)

    probability = between_probability(mean, sd, lower_bound, upper_bound)

    question_text = 'A type of electronic component has a lifetime that follows a normal distribution ' \
                    "with a mean of #{mean} hours and a standard deviation of #{sd} hours. " \
                    'What is the probability that a randomly chosen component will fail between ' \
                    "#{lower_bound} and #{upper_bound} hours of operation?"

    build_probability_problem(question_text, probability)
  end

  def generate_medication_dosage_problem
    mean = rand(4.0..8.0).round(1)
    sd = rand(0.5..1.5).round(1)
    threshold = (mean - rand(0.5..2.0)).round(1)

    probability = upper_tail_probability(mean, sd, threshold)

    question_text = 'The effective duration of a certain medication in the bloodstream is normally distributed ' \
                    "with a mean of #{mean} hours and a standard deviation of #{sd} hours. What is the probability " \
                    "that the medication remains effective for at least #{threshold} hours?"

    build_probability_problem(question_text, probability)
  end

  def generate_data_statistics_problem
    data = generate_random_data
    all_values = data.flatten

    statistics = calculate_statistics(all_values)

    format_data_statistics_problem(data, statistics)
  end

  def generate_random_data
    Array.new(5) do
      Array.new(5) { rand(7.0..12.0).round(1) }
    end
  end

  def calculate_statistics(values)
    mean = values.sum / values.length
    {
      mean: mean.round(2),
      median: rounded_median(values),
      mode: rounded_mode(values),
      range: rounded_range(values),
      std_dev: rounded_std_dev(values, mean),
      variance: rounded_variance(values, mean)
    }
  end

  def rounded_median(values)
    calculate_median(values).round(2)
  end

  def rounded_mode(values)
    calculate_mode(values).round(2)
  end

  def rounded_range(values)
    (values.max - values.min).round(2)
  end

  def rounded_std_dev(values, mean)
    Math.sqrt(calculate_variance(values, mean)).round(2)
  end

  def rounded_variance(values, mean)
    calculate_variance(values, mean).round(2)
  end

  def format_data_statistics_problem(data, statistics)
    {
      type: 'data_statistics',
      question: statistics_question_text,
      data_table: data,
      answers: statistics,
      input_fields: statistics_input_fields
    }
  end

  def statistics_question_text
    'Given the data, determine the mean, median, mode, range, standard deviation, and variance.' \
      "\n\nRound your answer to two (2) decimal places. Example: 99.44 " \
      'Do not include units. Do not use scientific notation.'
  end

  def statistics_input_fields
    [
      { label: 'Mean', key: 'mean' },
      { label: 'Median', key: 'median' },
      { label: 'Mode', key: 'mode' },
      { label: 'Range', key: 'range' },
      { label: 'Standard Deviation', key: 'std_dev' },
      { label: 'Variance', key: 'variance' }
    ]
  end

  def calculate_median(values)
    sorted = values.sort
    len = sorted.length
    if len.odd?
      sorted[len / 2]
    else
      (sorted[(len / 2) - 1] + sorted[len / 2]) / 2.0
    end
  end

  def calculate_mode(values)
    counts = values.each_with_object(Hash.new(0)) { |v, h| h[v] += 1 }
    max_count = counts.values.max
    modes = counts.select { |_k, v| v == max_count }.keys
    modes.first
  end

  def calculate_variance(values, mean)
    squared_diffs = values.map { |v| (v - mean)**2 }
    squared_diffs.sum / values.length
  end
end
