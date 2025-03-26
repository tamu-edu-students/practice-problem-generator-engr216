# Create a new module to hold all question text formatting methods
module ConfidenceIntervalQuestionText
  def battery_question_text(sample_size, sample_mean, pop_std, confidence_level)
    "A company tests a sample of #{sample_size} batteries " \
      "and finds that the mean lifetime is #{format_number(sample_mean)} hours. " \
      "Assume a standard deviation of #{format_number(pop_std)} hours, " \
      'and the lifetimes are approximately normally distributed. ' \
      "Construct a #{format_confidence_level(confidence_level)} confidence interval for the true mean " \
      'battery lifetime. Provide the lower bound and the upper bound.' \
      "#{rounding_instructions}"
  end

  def cereal_question_text(sample_size, sample_mean, pop_std, confidence_level)
    "A quality control team measures a sample of #{sample_size} boxes of cereal. " \
      "The sample has a mean fill of #{format_number(sample_mean)} grams. " \
      "Assume a standard deviation of #{format_number(pop_std)} grams, " \
      'and the fill amounts follow a normal distribution. ' \
      "Construct a #{format_confidence_level(confidence_level)} confidence interval for the true mean " \
      'fill of cereal boxes. Provide the lower bound and the upper bound.' \
      "#{rounding_instructions}"
  end

  def waiting_times_question_text(sample_size, sample_mean, pop_std, confidence_level)
    "A hospital records wait times for a sample of #{sample_size} customers, " \
      "with an average wait time of #{format_number(sample_mean)} minutes. " \
      "Assume a standard deviation of #{format_number(pop_std)} minutes " \
      'and that wait times are normally distributed, ' \
      "construct a #{format_confidence_level(confidence_level)} confidence interval for the true mean wait time. " \
      "Provide the lower bound and the upper bound.#{rounding_instructions}"
  end

  def car_mileage_question_text(sample_size, sample_mean, pop_std, confidence_level)
    "A random sample of #{sample_size} cars is tested for fuel efficiency. " \
      "The sample shows an average of #{format_number(sample_mean)} miles per gallon. " \
      "Assume a standard deviation of #{format_number(pop_std)} mpg, " \
      'and that the data are approximately normally distributed. ' \
      "Construct a #{format_confidence_level(confidence_level)} confidence interval for the " \
      'true mean fuel efficiency. ' \
      "Provide the lower bound and the upper bound.#{rounding_instructions}"
  end

  def produce_weight_question_text(sample_size, sample_mean, pop_std, confidence_level)
    "A grocery store weighs #{sample_size} pieces of produce, " \
      "finding an average weight of #{sample_mean.round(1)} grams. " \
      "The population standard deviation is #{pop_std.round(1)} grams, " \
      'and the weight is assumed to follow a normal distribution. ' \
      "Construct a #{format_confidence_level(confidence_level)} confidence interval for the true mean weight. " \
      "Provide the lower bound and the upper bound.#{rounding_instructions}"
  end

  def shipping_times_question_text(sample_size, sample_mean, pop_std, confidence_level)
    "A shipping company monitors #{sample_size} shipments and finds " \
      "the mean delivery time to be #{sample_mean.round(1)} hours. " \
      "Assume the population standard deviation is #{pop_std.round(1)}, " \
      'and delivery times follow a normal distribution. ' \
      "Construct a #{format_confidence_level(confidence_level)} confidence interval for the true mean delivery time. " \
      "Provide the lower bound and the upper bound.#{rounding_instructions}"
  end

  def manufacturing_diameter_question_text(sample_size, sample_mean, pop_std, confidence_level)
    "A factory measures the diameter of #{sample_size} parts, " \
      "obtaining a sample mean diameter of #{sample_mean.round(1)} mm. " \
      "The population standard deviation is #{pop_std.round(1)} mm, " \
      'and the diameters are approximately normally distributed. ' \
      "Construct a #{format_confidence_level(confidence_level)} confidence interval for the true mean diameter. " \
      "Provide the lower bound and the upper bound.#{rounding_instructions}"
  end

  def concentration_question_text(sample_size, sample_mean, pop_std, confidence_level)
    "In an environmental study, #{sample_size} water samples are tested, " \
      "yielding a mean concentration of #{sample_mean.round(1)} ppm. " \
      "Assume the population standard deviation is #{pop_std.round(1)} ppm, " \
      'and concentrations follow a normal distribution. ' \
      "Construct a #{format_confidence_level(confidence_level)} confidence interval for the true mean concentration. " \
      "Provide the lower bound and the upper bound.#{rounding_instructions}"
  end

  def phone_call_duration_question_text(sample_size, sample_mean, pop_std, confidence_level)
    "A telecom company records #{sample_size} phone calls, " \
      "finding a mean call duration of #{sample_mean.round(1)} seconds. " \
      "The population standard deviation is #{pop_std.round(1)} seconds, " \
      'and durations are assumed to be normally distributed. ' \
      "Construct a #{format_confidence_level(confidence_level)} confidence interval for the true mean call duration. " \
      "Provide the lower bound and the upper bound.#{rounding_instructions}"
  end

  def daily_water_usage_question_text(sample_size, sample_mean, pop_std, confidence_level)
    "A city measures the daily water usage of #{sample_size} households, " \
      "with a sample mean usage of #{sample_mean.round(1)} gallons. " \
      "Assume the population standard deviation is #{pop_std.round(1)} gallons, " \
      'and water usage is normally distributed. ' \
      "Construct a #{format_confidence_level(confidence_level)} confidence interval for the " \
      'true mean daily water usage. ' \
      "Provide the lower bound and the upper bound.#{rounding_instructions}"
  end

  def format_confidence_level(confidence_level)
    "#{confidence_level}%"
  end

  def rounding_instructions
    "\n\nRound your answer to two (2) decimal places. Do not include units. Do not use scientific notation."
  end

  # Helper method to format numbers.
  # If the number is whole, it returns an integer string; otherwise, it returns one decimal place.
  def format_number(num)
    f = num.to_f
    (f % 1).zero? ? f.to_i.to_s : f.round(1).to_s
  end
end
