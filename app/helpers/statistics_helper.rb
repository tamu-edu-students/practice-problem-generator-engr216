module StatisticsHelper
  def self.pnorm(z_score)
    if z_score < -10
      return 0.0
    elsif z_score > 10
      return 1.0
    end

    # use Ruby's built-in Math.erf function
    # Normal CDF = 0.5 * (1 + erf(z/sqrt(2)))
    0.5 * (1.0 + Math.erf(z_score / Math.sqrt(2.0)))
  end

  # Calculate mean of an array
  def mean(values)
    return nil if values.empty?

    values.sum.to_f / values.size
  end

  # Calculate variance of an array
  def variance(values)
    return 0.0 if values.size <= 1

    m = mean(values)
    sum_of_squares = values.sum { |x| (x - m)**2 }
    sum_of_squares / values.size.to_f
  end

  # Calculate standard deviation of an array
  def standard_deviation(values)
    return 0.0 if values.size <= 1

    Math.sqrt(variance(values))
  end
end
