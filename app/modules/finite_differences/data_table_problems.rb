# Module for data table finite difference problems
module FiniteDifferences
  # Utility module for data table operations
  module DataTableUtils
    def create_data_table(times, data_values, data_type = 'temperature')
      data_label = data_type == 'temperature' ? 'Temperature (°C)' : 'Displacement (m)'
      [
        ['Point', '1', '2', '3', '4', '5'],
        ['Time (s)', *times],
        [data_label, *data_values]
      ]
    end

    def create_velocity_data_table(positions, velocities)
      [
        ['Position (m)', *positions],
        ['Velocity (m/s)', *velocities]
      ]
    end

    def calculate_backward_diff_from_data(values, point, step_size)
      ((values[point] - values[point - 1]) / step_size).round(1)
    end

    def calculate_forward_diff_from_data(values, point, step_size)
      ((values[point + 1] - values[point]) / step_size).round(1)
    end

    def calculate_centered_diff_from_data(values, point, step_size)
      ((values[point + 1] - values[point - 1]) / (2 * step_size)).round(1)
    end

    def build_data_table_params(point, times, data_values)
      {
        point: point + 1,
        t1: times[0], t2: times[1], t3: times[2], t4: times[3], t5: times[4],
        D1: data_values[0], D2: data_values[1], D3: data_values[2],
        D4: data_values[3], D5: data_values[4]
      }
    end

    def build_velocity_profile_params(point, positions, velocities)
      {
        point: point + 1,
        y1: positions[0], y2: positions[1], y3: positions[2], y4: positions[3], y5: positions[4],
        u1: velocities[0], u2: velocities[1], u3: velocities[2], u4: velocities[3], u5: velocities[4],
        position: positions[point]
      }
    end
  end

  module DataTableProblems
    include DataTableUtils

    # Generate a problem using backward difference with data table
    def generate_data_table_backward_problem
      data = generate_cooling_data
      point = rand(1..4)

      # Get components for the problem
      backward_diff = calculate_backward_diff_from_data(data[:temperatures], point, data[:time_step])
      data_table = create_data_table(data[:times], data[:temperatures], 'temperature')

      # Build and return the complete problem
      build_data_table_backward_problem(data, point, backward_diff, data_table)
    end

    def build_data_table_backward_problem(data, point, backward_diff, data_table)
      params = build_data_table_params(point, data[:times], data[:temperatures])
      question_text = data_table_backward_text(params)

      build_finite_differences_problem(
        question_text,
        backward_diff,
        data_table: data_table,
        parameters: { answer: backward_diff }
      )
    end

    # Generate a problem using forward difference with data table
    def generate_data_table_forward_problem
      data = generate_falling_object_data
      point = rand(0..3) # Must be before last point

      # Get components for the problem
      forward_diff = calculate_forward_diff_from_data(data[:displacements], point, data[:time_step])
      data_table = create_data_table(data[:times], data[:displacements], 'displacement')

      # Build and return the complete problem
      build_data_table_forward_problem(data, point, forward_diff, data_table)
    end

    def build_data_table_forward_problem(data, point, forward_diff, data_table)
      params = build_data_table_params(point, data[:times], data[:displacements])
      question_text = data_table_forward_text(params)

      build_finite_differences_problem(
        question_text,
        forward_diff,
        data_table: data_table,
        parameters: { answer: forward_diff }
      )
    end

    # Generate centered difference problem for velocity profile
    def generate_velocity_profile_centered_problem
      data = generate_velocity_profile_data
      point = rand(1..3) # Point must be in middle (not first or last)

      # Get components for the problem
      centered_diff = calculate_centered_diff_from_data(data[:velocities], point, data[:position_step])
      data_table = create_velocity_data_table(data[:positions], data[:velocities])

      # Build and return the complete problem
      build_velocity_profile_problem(data, point, centered_diff, data_table)
    end

    def build_velocity_profile_problem(data, point, centered_diff, data_table)
      params = build_velocity_profile_params(point, data[:positions], data[:velocities])
      question_text = velocity_profile_centered_text(params)

      build_finite_differences_problem(
        question_text,
        centered_diff,
        data_table: data_table,
        parameters: { answer: centered_diff }
      )
    end

    private

    def generate_cooling_data
      # Create evenly spaced time points
      time_step = rand(1..3)
      times = Array.new(5) { |i| i * time_step }

      # Generate temperature values with a cooling trend
      start_temp = rand(85..95)
      temperatures = [start_temp]
      4.times do
        temperatures << (temperatures.last - rand(2..5)).round(1)
      end

      { times: times, temperatures: temperatures, time_step: time_step }
    end

    def generate_velocity_profile_data
      # Create evenly spaced position points
      position_step = rand(2..5) * 0.1
      positions = Array.new(5) { |i| (i * position_step).round(2) }

      # Generate velocity values with a parabolic profile
      mid_point = 2
      velocities = []
      5.times do |i|
        # Parabolic profile u = A * y * (H-y) where y is distance from wall
        distance_from_center = (i - mid_point).abs
        velocity = (10 - (2 * (distance_from_center**2))).round(1)
        velocities << velocity
      end

      { positions: positions, velocities: velocities, position_step: position_step }
    end

    def generate_falling_object_data
      # Create evenly spaced time points
      time_step = 1 # 1 second intervals
      times = Array.new(5) { |i| i * time_step }

      # Generate displacement values for a falling object (d = 0.5*g*t^2)
      g = 9.8 # acceleration due to gravity
      displacements = []
      times.each do |t|
        # Adding some randomness to make the problem more interesting
        displacement = (0.5 * g * (t**2)).round(1)
        displacements << displacement
      end

      { times: times, displacements: displacements, time_step: time_step }
    end
  end
end
