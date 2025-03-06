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
end
