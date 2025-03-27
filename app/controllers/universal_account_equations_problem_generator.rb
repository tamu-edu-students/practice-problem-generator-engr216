# This class generates Universal Account Equations (UAE) problems for students
class UniversalAccountEquationsProblemGenerator
  include UniversalAccountEquationsQuestionText
  include UniversalAccountEquationsProblemGenerators

  def initialize(category)
    @category = category
  end

  # Generate a single UAE problem
  def generate_questions
    [generate_uae_problem]
  end

  private

  # Generate a random UAE problem
  def generate_uae_problem
    generators = %i[
      roller_coaster_velocity
      jam_production_cost
      fuel_efficiency
      mixing_solution
      simple_interest
      electricity_bill
      weight_conversion
    ]

    send(:"generate_#{generators.sample}_problem")
  end
end
