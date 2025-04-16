# Module for probability calculation helpers
module ProbabilityCalculators
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

  def build_probability_problem(question_text, probability, template_id)
    {
      type: 'probability',
      question: question_text,
      answer: probability.round(2),
      input_fields: nil,
      template_id: template_id
    }
  end
end
