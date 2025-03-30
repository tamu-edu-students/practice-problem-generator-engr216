# This class generates collision problems for students
class CollisionProblemGenerator
  include CollisionQuestionText
  include CollisionProblemGenerators

  def initialize(category)
    @category = category
  end

  def generate_questions
    [generate_collision_problem]
  end

  private

  # Generate a random collision problem
  def generate_collision_problem
    # Get a generator method name from our list
    generator_name = generator_list.sample

    # Call the generator method
    send(generator_name)
  end

  # Get the list of available generator methods
  def generator_list
    %i[
      generate_bullet_block_question
      generate_electron_collision_question
      generate_ball_drop_question
      generate_car_collision_question
      generate_pool_ball_question
      generate_pendulum_collision_question
      generate_puck_collision_question
      generate_projectile_collision_question
      generate_falling_object_question
    ]
  end

  # Calculate momentum based on mass and velocity
  def calculate_momentum(mass, velocity)
    mass * velocity
  end

  # Calculate kinetic energy based on mass and velocity
  def calculate_kinetic_energy(mass, velocity)
    0.5 * mass * (velocity**2)
  end

  # Calculate final velocity after an elastic collision
  # For the first object
  def calculate_final_velocity_elastic_obj1(mass1, vel1, mass2, vel2)
    (((mass1 - mass2) * vel1) + (2 * mass2 * vel2)).to_f / (mass1 + mass2)
  end

  # Calculate final velocity after an elastic collision
  # For the second object
  def calculate_final_velocity_elastic_obj2(mass1, vel1, mass2, vel2)
    ((2 * mass1 * vel1) + ((mass2 - mass1) * vel2)).to_f / (mass1 + mass2)
  end

  # Calculate final velocity after an inelastic collision
  # Objects don't stick together, energy is lost
  def calculate_final_velocity_inelastic(mass1, vel1, mass2, vel2, coefficient_of_restitution)
    v_cm = ((mass1 * vel1) + (mass2 * vel2)).to_f / (mass1 + mass2)
    v_rel = vel2 - vel1
    v_rel_final = -coefficient_of_restitution * v_rel

    # First object's final velocity
    v1_final = v_cm - ((mass2 * v_rel_final).to_f / (mass1 + mass2))

    # Second object's final velocity
    v2_final = v_cm + ((mass1 * v_rel_final).to_f / (mass1 + mass2))

    [v1_final, v2_final]
  end

  # Calculate final velocity after a perfectly inelastic collision
  # Objects stick together
  def calculate_final_velocity_perfectly_inelastic(mass1, vel1, mass2, vel2)
    ((mass1 * vel1) + (mass2 * vel2)).to_f / (mass1 + mass2)
  end

  # Calculate energy lost in a collision
  def calculate_energy_lost(initial_energy, final_energy)
    initial_energy - final_energy
  end

  # Common instructions for all collision problems
  def rounding_instructions
    "\n\nRound your answer to two decimal places."
  end

  # Default input field configuration
  def default_input_field
    [{ type: 'numeric', label: 'Answer', key: 'answer' }]
  end

  # Build the question text for the problem
  def build_collision_problem(question_text, *)
    # Calculate the answer based on problem parameters
    answer = calculate_answer(question_text, *)

    result = {
      type: 'momentum & collisions',
      question: question_text,
      answer: answer,
      input_fields: default_input_field,
      parameters: format_parameters(*)
    }

    # Add debug info if in development mode
    add_debug_info(result) if Rails.env.development?

    result
  end

  # Calculate the answer based on the problem parameters
  def calculate_answer(question_text, *args)
    case question_text
    when /bullet moving at/
      bullet_mass, bullet_initial_speed, bullet_final_speed, block_mass = args
      initial_momentum = calculate_momentum(bullet_mass, bullet_initial_speed)
      final_momentum = calculate_momentum(bullet_mass, bullet_final_speed)
      block_velocity = (initial_momentum - final_momentum) / block_mass
      block_velocity.round(2)
    when /elastic collision with an initially stationary hydrogen atom/
      mass_ratio = args[0]
      # For elastic collision, energy transfer percentage
      (4.0 * mass_ratio / ((1 + mass_ratio)**2) * 100).round(2)
    when /soccer ball with mass/
      ball1_mass, ball2_mass, drop_height = args
      velocity = Math.sqrt(2 * 9.8 * drop_height)
      final_velocity = calculate_final_velocity_elastic_obj1(ball1_mass, velocity, ball2_mass, 0)
      ((final_velocity**2) / (2 * 9.8)).round(2)
    when /cars stick together/
      car1_mass, car1_speed, car2_mass, car2_speed = args
      calculate_final_velocity_perfectly_inelastic(car1_mass, car1_speed, car2_mass, car2_speed).round(2)
    when /pool ball of mass/
      _, initial_speed, angle = args
      (initial_speed * Math.sin(angle * Math::PI / 180)).round(2)
    when /pendulum bob is released/
      pendulum1_mass, pendulum2_mass, pendulum1_height = args
      velocity = Math.sqrt(2 * 9.8 * pendulum1_height / 100)
      final_velocity = calculate_final_velocity_elastic_obj2(pendulum1_mass, velocity, pendulum2_mass, 0)
      ((final_velocity**2) / (2 * 9.8) * 100).round(2)
    when /frictionless horizontal surface/
      puck1_mass, puck1_speed, puck2_mass = args
      final_velocity1 = calculate_final_velocity_elastic_obj1(puck1_mass, puck1_speed, puck2_mass, 0)
      final_velocity2 = calculate_final_velocity_elastic_obj2(puck1_mass, puck1_speed, puck2_mass, 0)
      { puck1: final_velocity1.round(2), puck2: final_velocity2.round(2) }
    when /projectile traveling horizontally/
      projectile_mass, target_mass, projectile_speed = args
      velocity = calculate_final_velocity_perfectly_inelastic(projectile_mass, projectile_speed, target_mass, 0)
      ((velocity**2) / (2 * 9.8)).round(2)
    when /dropped onto a/
      _, _, initial_height, restitution = args
      velocity = Math.sqrt(2 * 9.8 * initial_height)
      final_velocity = restitution * velocity
      ((final_velocity**2) / (2 * 9.8)).round(2)
    else
      0.0
    end
  end

  # Format parameters for storing with the problem
  def format_parameters(*args)
    # Convert args to a hash with descriptive keys
    params = {}
    args.each_with_index do |arg, index|
      params["param_#{index + 1}"] = arg
    end
    params
  end

  # Add debug information for development purposes
  def add_debug_info(problem)
    problem[:debug_info] = {
      generator: self.class.name,
      timestamp: Time.zone.now
    }
  end
end
