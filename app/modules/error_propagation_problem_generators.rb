# rubocop:disable Layout/LineLength, Metrics/MethodLength

module ErrorPropagationProblemGenerators
  module_function

  # Generate single variable uncertainty problems
  def single_variable_problems
    [
      centripetal_acceleration_problem,
      pendulum_period_problem,
      spring_potential_energy_problem,
      projectile_range_problem
    ]
  end

  # Generate multi-variable uncertainty problems
  def multi_variable_problems
    [
      rectangular_area_problem,
      circular_area_problem,
      volume_problem,
      density_problem
    ]
  end

  # Generate fractional error problems
  def fractional_error_problems
    [
      velocity_fractional_problem,
      gravitational_force_fractional_problem,
      kinetic_energy_fractional_problem
    ]
  end

  # Single Variable Problems
  
  # Centripetal acceleration problem
  def centripetal_acceleration_problem
    theta_deg = rand(15.0..20.0).round(1)
    theta_unc = rand(0.8..1.2).round(1)
    
    g = 9.81  # m/s²
    theta_rad = theta_deg * Math::PI / 180.0
    derivative = g * (1 / Math.cos(theta_rad)**2) * (Math::PI / 180.0)
    uncertainty = ErrorPropagationCalculators.calculate_uncertainty(derivative, theta_unc)
    
    {
      question: ErrorPropagationQuestionText.single_variable_template(
        "a car rounding a banked curve",
        "a = g × tan(θ)",
        "θ",
        theta_deg,
        theta_unc,
        "°",
        "centripetal acceleration",
        { symbol: "g", value: "9.81", units: "m/s²" }
      ),
      answer: uncertainty.to_s,
      field_label: "Uncertainty in centripetal acceleration (m/s²)",
      explanation: ErrorPropagationQuestionText.single_variable_explanation(
        "a = g × tan(θ)",
        "g × sec²(θ) × (π/180)",
        "θ",
        theta_deg,
        theta_unc,
        uncertainty
      )
    }
  end

  # Pendulum period problem
  def pendulum_period_problem
    length = rand(0.8..1.2).round(2)
    length_unc = rand(0.01..0.02).round(2)
    
    g = 9.81  # m/s²
    derivative = Math::PI * (length**(-0.5)) / Math.sqrt(g)
    uncertainty = ErrorPropagationCalculators.calculate_uncertainty(derivative, length_unc)
    
    {
      question: ErrorPropagationQuestionText.single_variable_template(
        "a simple pendulum",
        "T = 2π × √(L/g)",
        "L",
        length,
        length_unc,
        "m",
        "period",
        { symbol: "g", value: "9.81", units: "m/s²" }
      ),
      answer: uncertainty.to_s,
      field_label: "Uncertainty in period (s)",
      explanation: ErrorPropagationQuestionText.single_variable_explanation(
        "T = 2π × √(L/g)",
        "π × L^(-1/2) / √g",
        "L",
        length,
        length_unc,
        uncertainty
      )
    }
  end

  # Spring potential energy problem
  def spring_potential_energy_problem
    distance = rand(0.15..0.25).round(2)
    distance_unc = rand(0.005..0.01).round(3)
    k = rand(75..125)  # N/m
    
    derivative = k * distance
    uncertainty = ErrorPropagationCalculators.calculate_uncertainty(derivative, distance_unc)
    
    {
      question: ErrorPropagationQuestionText.single_variable_template(
        "a compressed spring",
        "U = (1/2) × k × x²",
        "x",
        distance,
        distance_unc,
        "m",
        "potential energy",
        { symbol: "k", value: k.to_s, units: "N/m" }
      ),
      answer: uncertainty.to_s,
      field_label: "Uncertainty in potential energy (J)",
      explanation: ErrorPropagationQuestionText.single_variable_explanation(
        "U = (1/2) × k × x²",
        "k × x",
        "x",
        distance,
        distance_unc,
        uncertainty
      )
    }
  end

  # Projectile range problem
  def projectile_range_problem
    angle_deg = rand(40.0..50.0).round(1)
    angle_unc = rand(0.5..1.5).round(1)
    velocity = rand(20.0..30.0).round(1)
    g = 9.81
    
    angle_rad = angle_deg * Math::PI / 180.0
    derivative = (velocity**2 / g) * (1 - 2 * (Math.sin(angle_rad)**2)) * Math.cos(angle_rad) * (Math::PI / 180.0)
    uncertainty = ErrorPropagationCalculators.calculate_uncertainty(derivative.abs, angle_unc)
    
    {
      question: ErrorPropagationQuestionText.single_variable_template(
        "a projectile",
        "R = (v² × sin(2θ))/g",
        "θ",
        angle_deg,
        angle_unc,
        "°",
        "range",
        { symbol: "v", value: velocity.to_s, units: "m/s" }
      ),
      answer: uncertainty.to_s,
      field_label: "Uncertainty in range (m)",
      explanation: ErrorPropagationQuestionText.single_variable_explanation(
        "R = (v² × sin(2θ))/g",
        "(v²/g) × 2cos(2θ) × (π/180)",
        "θ",
        angle_deg,
        angle_unc,
        uncertainty
      )
    }
  end

  # Multi-variable Problems
  
  # Rectangular area problem
  def rectangular_area_problem
    length = rand(20.0..30.0).round(1)
    width = rand(10.0..15.0).round(1)
    length_unc = rand(0.1..0.3).round(1)
    width_unc = rand(0.1..0.3).round(1)
    
    # Partial derivatives
    dl = width
    dw = length
    
    # Calculate uncertainty
    uncertainty = ErrorPropagationCalculators.calculate_combined_uncertainty(
      [dl, dw],
      [length_unc, width_unc]
    )
    
    {
      question: ErrorPropagationQuestionText.multi_variable_template(
        "area of a rectangular plot",
        "A = L × W",
        "L",
        length,
        length_unc,
        "m",
        "W",
        width,
        width_unc,
        "m"
      ),
      answer: uncertainty.to_s,
      field_label: "Uncertainty in area (m²)",
      explanation: ErrorPropagationQuestionText.multi_variable_explanation(
        "A = L × W",
        ["W", "L"],
        [length, width],
        [length_unc, width_unc],
        uncertainty
      )
    }
  end

  # Circular area problem
  def circular_area_problem
    radius = rand(5.0..10.0).round(1)
    radius_unc = rand(0.1..0.2).round(1)
    
    # Partial derivative
    dr = 2 * Math::PI * radius
    
    # Calculate uncertainty
    uncertainty = ErrorPropagationCalculators.calculate_uncertainty(dr, radius_unc)
    
    {
      question: ErrorPropagationQuestionText.single_variable_template(
        "a circular field",
        "A = πr²",
        "r",
        radius,
        radius_unc,
        "m",
        "area"
      ),
      answer: uncertainty.to_s,
      field_label: "Uncertainty in area (m²)",
      explanation: ErrorPropagationQuestionText.single_variable_explanation(
        "A = πr²",
        "2πr",
        "r",
        radius,
        radius_unc,
        uncertainty
      )
    }
  end

  # Volume problem
  def volume_problem
    length = rand(15.0..20.0).round(1)
    width = rand(8.0..12.0).round(1)
    height = rand(4.0..6.0).round(1)
    length_unc = rand(0.1..0.2).round(1)
    width_unc = rand(0.1..0.2).round(1)
    height_unc = rand(0.1..0.2).round(1)
    
    # Partial derivatives
    dl = width * height
    dw = length * height
    dh = length * width
    
    # Calculate uncertainty
    uncertainty = ErrorPropagationCalculators.calculate_combined_uncertainty(
      [dl, dw, dh],
      [length_unc, width_unc, height_unc]
    )
    
    # Since this is a three-variable problem, we'll customize the question text
    question = "The volume of a rectangular container is calculated using V = L × W × H. Given L = #{length} ± #{length_unc} cm, W = #{width} ± #{width_unc} cm, and H = #{height} ± #{height_unc} cm, calculate the uncertainty of the volume."
    
    {
      question: question,
      answer: uncertainty.to_s,
      field_label: "Uncertainty in volume (cm³)",
      explanation: ErrorPropagationQuestionText.multi_variable_explanation(
        "V = L × W × H",
        ["W × H", "L × H", "L × W"],
        [length, width, height],
        [length_unc, width_unc, height_unc],
        uncertainty
      )
    }
  end

  # Density problem
  def density_problem
    mass = rand(80.0..120.0).round(1)
    volume = rand(30.0..50.0).round(1)
    mass_unc = rand(0.5..1.0).round(1)
    volume_unc = rand(0.5..1.0).round(1)
    
    # Partial derivatives
    dm = 1.0 / volume
    dv = -mass / (volume**2)
    
    # Calculate uncertainty
    uncertainty = ErrorPropagationCalculators.calculate_combined_uncertainty(
      [dm, dv],
      [mass_unc, volume_unc]
    )
    
    {
      question: ErrorPropagationQuestionText.multi_variable_template(
        "density of a material",
        "ρ = m/V",
        "m",
        mass,
        mass_unc,
        "g",
        "V",
        volume,
        volume_unc,
        "cm³"
      ),
      answer: uncertainty.to_s,
      field_label: "Uncertainty in density (g/cm³)",
      explanation: ErrorPropagationQuestionText.multi_variable_explanation(
        "ρ = m/V",
        ["1/V", "-m/V²"],
        [mass, volume],
        [mass_unc, volume_unc],
        uncertainty
      )
    }
  end

  # Fractional Error Problems
  
  # Velocity fractional problem
  def velocity_fractional_problem
    h_percentage = rand(5..10)
    velocity_percentage = (0.5 * h_percentage).round(1)
    
    {
      question: ErrorPropagationQuestionText.fractional_error_template(
        "speed of a yo-yo's center of mass",
        "v = 2 × √(g×h/3)",
        "h",
        h_percentage
      ),
      answer: velocity_percentage.to_s,
      field_label: "Relative uncertainty in speed (%)",
      explanation: ErrorPropagationQuestionText.fractional_error_explanation(
        "v ∝ √h",
        "h",
        0.5,
        velocity_percentage
      )
    }
  end

  # Gravitational force fractional problem
  def gravitational_force_fractional_problem
    r_percentage = rand(3..8)
    force_percentage = (2 * r_percentage).round(1)
    
    {
      question: ErrorPropagationQuestionText.fractional_error_template(
        "gravitational force",
        "F = G×m₁×m₂/r²",
        "r",
        r_percentage
      ),
      answer: force_percentage.to_s,
      field_label: "Relative uncertainty in force (%)",
      explanation: ErrorPropagationQuestionText.fractional_error_explanation(
        "F ∝ 1/r²",
        "r",
        -2,
        force_percentage
      )
    }
  end

  # Kinetic energy fractional problem
  def kinetic_energy_fractional_problem
    v_percentage = rand(4..9)
    energy_percentage = (2 * v_percentage).round(1)
    
    {
      question: ErrorPropagationQuestionText.fractional_error_template(
        "kinetic energy",
        "KE = (1/2)×m×v²",
        "v",
        v_percentage
      ),
      answer: energy_percentage.to_s,
      field_label: "Relative uncertainty in energy (%)",
      explanation: ErrorPropagationQuestionText.fractional_error_explanation(
        "KE ∝ v²",
        "v",
        2,
        energy_percentage
      )
    }
  end

  # Add yo-yo problem with nested square roots
  def yo_yo_problem
    # Relative uncertainty in h
    h_uncertainty = rand(3..8)
    
    {
      question: "The speed of a yo-yo's center of mass is given by v = 2 × √(g×h/3). If the relative uncertainty of h is #{h_uncertainty}%, what is the relative uncertainty in the speed of a yo-yo's center of mass?",
      answer: (h_uncertainty.to_f / 2.0).round(1).to_s,
      explanation: ErrorPropagationQuestionText.fractional_error_explanation("v = 2 × √(g×h/3)", "h", 0.5, (h_uncertainty.to_f / 2.0).round(1)),
      field_label: "Relative uncertainty in speed (%)"
    }
  end
end

# rubocop:enable Layout/LineLength, Metrics/MethodLength 