# Module containing all finite differences problem generators
module FiniteDifferencesProblemGenerators
  def generate_polynomial_all_approximations_problem
    # Generate coefficients for the polynomial
    a = rand(5..30)
    b = rand(-15..15)
    c = rand(-10..10)
    d = rand(-100..100)
    
    # Point to evaluate the derivative at and step size
    x0 = rand(1..5)
    h = 0.1 * rand(1..5)
    
    # Define lambda functions for the function and its derivative
    f = ->(x) { a * x**3 + b * x**2 + c * x + d }
    df = ->(x) { 3 * a * x**2 + 2 * b * x + c }
    
    # Calculate the approximations
    forward_diff = ((f.call(x0 + h) - f.call(x0)) / h).round
    backward_diff = ((f.call(x0) - f.call(x0 - h)) / h).round
    centered_diff = ((f.call(x0 + h) - f.call(x0 - h)) / (2 * h)).round
    true_derivative = df.call(x0).round
    
    # Create question parameters
    params = {
      a: a, b: b, c: c, d: d,
      x0: x0, h: h.round(1)
    }
    
    # Get formatted question text
    question_text = polynomial_all_approximations_text(params)
    
    # Return the complete problem
    {
      type: 'finite_differences',
      question: question_text,
      answer: true_derivative,
      input_fields: [
        { label: 'Forward Difference', key: 'forward_diff' },
        { label: 'Backward Difference', key: 'backward_diff' },
        { label: 'Centered Difference', key: 'centered_diff' },
        { label: 'True Derivative', key: 'true_derivative' }
      ],
      parameters: {
        forward_diff: forward_diff,
        backward_diff: backward_diff,
        centered_diff: centered_diff,
        true_derivative: true_derivative
      }
    }
  end

  def generate_data_table_backward_problem
    # Create evenly spaced time points
    times = Array.new(5) { |i| (10.0 + i * 0.2).round(1) }
    
    # Generate temperature values with a cooling trend
    temperatures = [rand(85..95)]
    4.times do |i|
      temperatures << (temperatures.last - rand(5..10)).round(1)
    end
    
    # Point to calculate derivative at (3rd or 4th point)
    point = rand(3..4)
    
    # Calculate backward difference at the specified point
    h = times[point] - times[point-1]
    backward_diff = ((temperatures[point] - temperatures[point-1]) / h).round(1)
    
    # Create properly formatted data table
    data_table = [
      ["Point", "1", "2", "3", "4", "5"],
      ["Time (s)", *times],
      ["Temperature (°C)", *temperatures]
    ]
    
    # Build question parameters
    params = {
      point: point + 1,
      t1: times[0], t2: times[1], t3: times[2], t4: times[3], t5: times[4],
      T1: temperatures[0], T2: temperatures[1], T3: temperatures[2], 
      T4: temperatures[3], T5: temperatures[4]
    }
    
    # Get formatted question text
    question_text = data_table_backward_text(params)
    
    # Return the complete problem
    {
      type: 'finite_differences',
      question: question_text,
      data_table: data_table,
      answer: backward_diff,
      input_fields: default_input_field,
      parameters: { answer: backward_diff }
    }
  end

  def generate_trig_function_centered_problem
    # Generate parameters for the sine function
    a_coef = rand(2..10)
    b_coef = rand(1..5)
    
    # Point to evaluate and step size
    x0 = rand(1..3)
    h = [0.1, 0.2, 0.5].sample
    
    # Define lambda functions for the function and its derivative
    f = ->(x) { a_coef * Math.sin(b_coef * x) }
    df = ->(x) { a_coef * b_coef * Math.cos(b_coef * x) }
    
    # Calculate centered difference
    f_plus_h = f.call(x0 + h)
    f_minus_h = f.call(x0 - h)
    centered_diff = centered_difference(f_plus_h, f_minus_h, h).round(2)
    
    # Calculate true derivative
    true_derivative = df.call(x0).round(2)
    
    # Create parameters hash
    params = {
      A: a_coef,
      B: b_coef,
      x0: x0,
      h: h
    }
    
    # Get formatted question text
    question_text = trig_function_centered_text(params)
    
    # Return the complete problem
    {
      type: 'finite_differences',
      question: question_text,
      answer: centered_diff,
      input_fields: default_input_field,
      parameters: { answer: centered_diff }
    }
  end

  def generate_data_table_forward_problem
    # Generate 3 time points
    start_time = rand(0..5) / 10.0
    time_increment = 0.5
    times = (0..2).map { |i| (start_time + i * time_increment).round(1) }
    
    # Generate displacements with increasing acceleration
    # d = d₀ + v₀t + 0.5at²
    d0 = 0
    v0 = rand(10..20)
    a = 9.8  # Acceleration due to gravity
    
    displacements = times.map { |t| (d0 + v0 * t + 0.5 * a * t**2).round(2) }
    
    # Choose a point for the derivative calculation
    point = rand(1..2)
    
    # Calculate forward difference at the chosen point (velocity)
    h = times[point] - times[point-1]  # Time difference
    answer = ((displacements[point] - displacements[point-1]) / h).round(2)
    
    # Create data table
    data_table = [
      ["Time (s)", *times],
      ["Displacement (m)", *displacements]
    ]
    
    # Create parameters hash
    params = {
      point: point,
      parameters: { answer: answer },
      data_table: data_table
    }
    
    # Build and return the problem
    question_text = data_table_forward_text(params)
    build_finite_differences_problem(question_text, answer, params)
  end

  def generate_quadratic_function_comparison_problem
    # Generate parameters for a quadratic function f(x) = ax² + bx + c
    a = rand(1..5)
    b = rand(-10..10)
    c = rand(-10..10)
    x0 = rand(1..5)
    h = [0.1, 0.2, 0.5, 1.0].sample
    
    # Calculate function values
    f_x0 = (a * x0**2) + (b * x0) + c
    f_x0_plus_h = (a * (x0 + h)**2) + (b * (x0 + h)) + c
    f_x0_minus_h = (a * (x0 - h)**2) + (b * (x0 - h)) + c
    
    # Calculate derivatives
    forward_diff = forward_difference(f_x0, f_x0_plus_h, h).round(1)
    backward_diff = backward_difference(f_x0, f_x0_minus_h, h).round(1)
    
    # Calculate true derivative: 2ax + b
    true_derivative = (2 * a * x0 + b).round(1)
    
    # Create parameters hash
    params = {
      a: a, b: b, c: c, x0: x0, h: h,
      parameters: {
        forward_diff: forward_diff,
        backward_diff: backward_diff,
        true_derivative: true_derivative
      },
      input_fields: [
        { label: 'Forward Difference', key: 'forward_diff' },
        { label: 'Backward Difference', key: 'backward_diff' },
        { label: 'True Derivative', key: 'true_derivative' }
      ]
    }
    
    # Build and return the problem
    question_text = quadratic_function_comparison_text(params)
    build_finite_differences_problem(question_text, true_derivative, params)
  end

  def generate_velocity_profile_centered_problem
    # Generate 3 position points
    position_increment = rand(10..50)
    positions = (0..2).map { |i| (i * position_increment).round(1) }
    
    # Generate speeds with a pattern (could be accelerating or decelerating)
    acceleration = [-2, -1, 1, 2].sample
    base_speed = rand(20..50)
    speeds = positions.map { |p| (base_speed + acceleration * p + rand(-5..5)).round(1) }
    
    # Choose the middle position for acceleration calculation
    position = positions[1]
    
    # Calculate centered difference (acceleration)
    h = positions[1] - positions[0]  # Position difference (assuming equal spacing)
    answer = ((speeds[2] - speeds[0]) / (2 * h)).round(1)
    
    # Create data table
    data_table = [
      ["Position (m)", *positions],
      ["Speed (m/s)", *speeds]
    ]
    
    # Create parameters hash
    params = {
      position: position,
      x1: positions[0], x2: positions[1], x3: positions[2],
      v1: speeds[0], v2: speeds[1], v3: speeds[2],
      data_table: data_table
    }
    
    # Get formatted question text
    question_text = velocity_profile_centered_text(params)
    
    # Return the complete problem
    {
      type: 'finite_differences',
      question: question_text,
      data_table: data_table,
      answer: answer,
      input_fields: default_input_field,
      parameters: { answer: answer }
    }
  end

  def velocity_profile_centered_text(params)
    <<~TEXT
      A car's speed at different positions is given in the table. Estimate the acceleration at position #{params[:position]} using the centered difference method.
      
      Round your answer to one (1) decimal place. Example: 12.3
      Do not include units. Do not use scientific notation.
    TEXT
  end

  def generate_natural_log_derivative_problem
    # Generate parameters
    x0 = rand(1..5)
    h = [0.1, 0.2, 0.5].sample
    
    # Calculate function values for ln(x)
    f_x0 = Math.log(x0)
    f_x0_plus_h = Math.log(x0 + h)
    f_x0_minus_h = Math.log(x0 - h)
    
    # Calculate derivatives using different methods
    forward_diff = forward_difference(f_x0, f_x0_plus_h, h).round(3)
    backward_diff = backward_difference(f_x0, f_x0_minus_h, h).round(3)
    centered_diff = centered_difference(f_x0_plus_h, f_x0_minus_h, h).round(3)
    
    # True derivative of ln(x) is 1/x
    true_derivative = (1.0 / x0).round(3)
    
    # Create parameters hash
    params = {
      x0: x0, h: h,
      parameters: {
        forward_diff: forward_diff,
        backward_diff: backward_diff,
        centered_diff: centered_diff,
        true_derivative: true_derivative
      },
      input_fields: [
        { label: 'Forward Difference', key: 'forward_diff' },
        { label: 'Backward Difference', key: 'backward_diff' },
        { label: 'Centered Difference', key: 'centered_diff' }
      ]
    }
    
    # Build and return the problem
    question_text = natural_log_derivative_text(params)
    build_finite_differences_problem(question_text, true_derivative, params)
  end

  def generate_force_vs_time_backward_problem
    # Generate time points and force values
    t1 = rand(1..5)
    t2 = t1 + rand(1..3)
    f1 = rand(10..50)
    f2 = rand(10..50)
    
    # Calculate backward difference
    h = t2 - t1
    answer = ((f2 - f1) / h).round(1)
    
    # Create data table
    data_table = [
      ["Time (s)", t1.to_s, t2.to_s],
      ["Force (N)", f1.to_s, f2.to_s]
    ]
    
    # Create parameters hash
    params = {
      t1: t1, t2: t2, f1: f1, f2: f2
    }
    
    # Get formatted question text
    question_text = force_vs_time_backward_text(params)
    
    # Return the complete problem
    {
      type: 'finite_differences',
      question: question_text,
      data_table: data_table,
      answer: answer,
      input_fields: default_input_field,
      parameters: { answer: answer }
    }
  end

  def generate_function_table_all_methods_problem
    # Generate function values
    f_left = rand(10..50)
    f_center = rand(10..50)
    f_right = rand(10..50)
    h = [0.5, 1.0, 2.0].sample
    
    # Calculate derivatives using different methods
    forward_diff = ((f_right - f_center) / h).round(0)
    backward_diff = ((f_center - f_left) / h).round(0)
    centered_diff = ((f_right - f_left) / (2 * h)).round(0)
    
    # Create parameters hash
    params = {
      f_left: f_left, f_center: f_center, f_right: f_right, h: h,
      parameters: {
        forward_diff: forward_diff,
        backward_diff: backward_diff,
        centered_diff: centered_diff
      },
      input_fields: [
        { label: 'Forward Difference', key: 'forward_diff' },
        { label: 'Backward Difference', key: 'backward_diff' },
        { label: 'Centered Difference', key: 'centered_diff' }
      ]
    }
    
    # Build and return the problem
    question_text = function_table_all_methods_text(params)
    build_finite_differences_problem(question_text, centered_diff, params)
  end

  def generate_cooling_curve_centered_problem
    # Generate temperature values with a cooling trend
    temperatures = []
    initial_temp = rand(80..120)
    temperatures << initial_temp
    
    # Generate decreasing temperatures
    4.times do |i|
      cooling_rate = rand(1..5) * -1  # Negative cooling rate
      temperatures << (temperatures.last + cooling_rate).round(1)
    end
    
    # Time points with fixed interval
    time_interval = 9  # 9 seconds between measurements
    times = 5.times.map { |i| i * time_interval }
    
    # We want the third time point (index 2)
    point_index = 2
    
    # Calculate centered difference at the specified point
    h = time_interval
    centered_diff = ((temperatures[point_index+1] - temperatures[point_index-1]) / (2 * h)).round(1)
    
    # Create data table
    data_table = [
      ["Time (s)", *times],
      ["Temperature (°C)", *temperatures]
    ]
    
    # Create parameters hash
    params = {
      dt: time_interval,
      t1: times[0], t2: times[1], t3: times[2], t4: times[3], t5: times[4],
      T1: temperatures[0], T2: temperatures[1], T3: temperatures[2], 
      T4: temperatures[3], T5: temperatures[4],
      data_table: data_table  # Make sure to include the data table
    }
    
    # Get formatted question text
    question_text = cooling_curve_centered_text(params)
    
    # Return the complete problem with the data table
    {
      type: 'finite_differences',
      question: question_text,
      data_table: data_table,  # Include the data table here
      answer: centered_diff,
      input_fields: default_input_field,
      parameters: { answer: centered_diff }
    }
  end
end 