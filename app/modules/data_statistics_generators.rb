# Module for data statistics problem generation
module DataStatisticsGenerators
  def generate_data_statistics_problem
    data = generate_random_data
    all_values = data.flatten

    statistics = calculate_statistics(all_values)

    format_data_statistics_problem(data, statistics)
  end

  def generate_random_data
    Array.new(5) do
      Array.new(5) { rand(7.0..12.0).round(1) }
    end
  end

  def calculate_statistics(values)
    mean = values.sum / values.length
    {
      mean: mean.round(2),
      median: rounded_median(values),
      mode: rounded_mode(values),
      range: rounded_range(values),
      std_dev: rounded_std_dev(values, mean),
      variance: rounded_variance(values, mean)
    }
  end

  def rounded_median(values)
    calculate_median(values).round(2)
  end

  def rounded_mode(values)
    calculate_mode(values).round(2)
  end

  def rounded_range(values)
    (values.max - values.min).round(2)
  end

  def rounded_std_dev(values, mean)
    Math.sqrt(calculate_variance(values, mean)).round(2)
  end

  def rounded_variance(values, mean)
    calculate_variance(values, mean).round(2)
  end

  def format_data_statistics_problem(data, statistics)
    {
      type: 'data_statistics',
      question: statistics_question_text,
      data_table: data,
      answers: statistics,
      input_fields: statistics_input_fields,
      template_id: 10
    }
  end

  def statistics_input_fields
    [
      { label: 'Mean', key: 'mean' },
      { label: 'Median', key: 'median' },
      { label: 'Mode', key: 'mode' },
      { label: 'Range', key: 'range' },
      { label: 'Standard Deviation', key: 'std_dev' },
      { label: 'Variance', key: 'variance' }
    ]
  end

  def calculate_median(values)
    sorted = values.sort
    len = sorted.length
    if len.odd?
      sorted[len / 2]
    else
      (sorted[(len / 2) - 1] + sorted[len / 2]) / 2.0
    end
  end

  def calculate_mode(values)
    counts = values.each_with_object(Hash.new(0)) { |v, h| h[v] += 1 }
    max_count = counts.values.max
    modes = counts.select { |_k, v| v == max_count }.keys
    modes.first
  end

  def calculate_variance(values, mean)
    squared_diffs = values.map { |v| (v - mean)**2 }
    squared_diffs.sum / values.length
  end
end
