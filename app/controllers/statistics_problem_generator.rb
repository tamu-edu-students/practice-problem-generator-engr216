# This class generates statistics problems by using functionality from included modules
class StatisticsProblemGenerator
  # Include extracted modules
  include StatisticsQuestionText
  include ProbabilityProblemGenerators
  include DataStatisticsGenerators
  include ProbabilityCalculators

  def initialize(category)
    @category = category
  end

  # Generate both types of questions
  def generate_questions
    [generate_probability_problem, generate_data_statistics_problem]
  end

  private

  # Select a random probability problem generator method
  def generate_probability_problem
    send(%i[generate_machine_repair_problem generate_produce_weight_problem
            generate_assembly_line_problem generate_battery_lifespan_problem
            generate_customer_wait_time_problem generate_package_weight_problem
            generate_exam_score_problem generate_component_lifetime_problem
            generate_medication_dosage_problem].sample)
  end
end
