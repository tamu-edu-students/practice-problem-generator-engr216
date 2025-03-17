# Module for statistics problem question text formatting
module StatisticsQuestionText
  def statistics_question_text
    'Given the data, determine the mean, median, mode, range, standard deviation, and variance.' \
      "\n\nRound your answer to two (2) decimal places. Example: 99.44 " \
      'Do not include units. Do not use scientific notation.'
  end

  def answer_format_notes
    "\n\nYour answer should be a number between 0.0 and 100.0. Round your answer to two (2) decimal places. " \
      'Example: 99.44 Do not include units. Do not use scientific notation.'
  end

  def machine_repair_question_text(mean, std_dev, threshold)
    "A machine in a packaging plant requires an average repair time of #{mean} hours " \
    "with a standard deviation of #{std_dev} hours, assuming repair times follow a " \
    'normal distribution. What is the probability that a repair will take longer ' \
    "than #{threshold} hours?" + answer_format_notes
  end

  def produce_weight_question_text(mean, std_dev, lower_bound, upper_bound)
    "The weight of produce at a local market is normally distributed with a mean of #{mean} grams " \
    "and a standard deviation of #{std_dev} grams. What is the probability that a randomly chosen piece " \
    "of produce weighs between #{lower_bound} grams and #{upper_bound} grams?" + answer_format_notes
  end

  def assembly_line_question_text(mean, std_dev, threshold)
    "An assembly line produces an average of #{mean} units per hour with a standard deviation " \
    "of #{std_dev} units, assuming a normal distribution. What is the probability that the line " \
    "produces at least #{threshold} units in one hour?" + answer_format_notes
  end

  def battery_lifespan_question_text(mean, std_dev, threshold)
    "A certain type of battery has a mean lifetime of #{mean} days and a standard deviation " \
    "of #{std_dev} days, assuming a normal distribution. What is the probability that a randomly " \
    "selected battery will last less than #{threshold} days?" + answer_format_notes
  end

  def customer_wait_time_question_text(mean, std_dev, lower_bound, upper_bound)
    "A customer service center has an average wait time of #{mean} minutes and a standard deviation " \
    "of #{std_dev} minutes. Assuming wait times are normally distributed, what is the probability " \
    "that a customer waits between #{lower_bound} and #{upper_bound} minutes?" + answer_format_notes
  end

  def package_weight_question_text(mean, std_dev, threshold)
    'Packages shipped by a company have weights that are normally distributed ' \
    "with a mean of #{mean} kilograms and a standard deviation of #{std_dev} kilograms. " \
    "What is the probability that a package weighs more than #{threshold} kilograms?" + answer_format_notes
  end

  def exam_score_question_text(mean, std_dev, pass_score)
    "Scores on a standardized exam are normally distributed with a mean of #{mean} points " \
    "and a standard deviation of #{std_dev} points. If a passing score is #{pass_score}, " \
    'what is the probability that a randomly selected test-taker will pass?' + answer_format_notes
  end

  def component_lifetime_question_text(mean, std_dev, lower_bound, upper_bound)
    'A type of electronic component has a lifetime that follows a normal distribution ' \
    "with a mean of #{mean} hours and a standard deviation of #{std_dev} hours. " \
    'What is the probability that a randomly chosen component will fail between ' \
    "#{lower_bound} and #{upper_bound} hours of operation?" + answer_format_notes
  end

  def medication_dosage_question_text(mean, std_dev, threshold)
    'The effective duration of a certain medication in the bloodstream is normally distributed ' \
    "with a mean of #{mean} hours and a standard deviation of #{std_dev} hours. What is the probability " \
    "that the medication remains effective for at least #{threshold} hours?" + answer_format_notes
  end
end
