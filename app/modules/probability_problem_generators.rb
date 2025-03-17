# Module for probability problem generation
module ProbabilityProblemGenerators
  def generate_machine_repair_problem
    mean = rand(5.0..15.0).round(1)
    std_dev = rand(1.0..3.0).round(1)
    threshold = (mean + rand(-1.0..2.0)).round(1)

    probability = upper_tail_probability(mean, std_dev, threshold)

    question_text = machine_repair_question_text(mean, std_dev, threshold)
    build_probability_problem(question_text, probability)
  end

  def generate_produce_weight_problem
    mean = rand(150.0..500.0).round(1)
    sd = rand(10.0..50.0).round(1)
    lower_bound = (mean - rand(10.0..30.0)).round(1)
    upper_bound = (mean + rand(10.0..30.0)).round(1)

    probability = between_probability(mean, sd, lower_bound, upper_bound)

    question_text = produce_weight_question_text(mean, sd, lower_bound, upper_bound)
    build_probability_problem(question_text, probability)
  end

  def generate_assembly_line_problem
    mean = rand(50.0..200.0).round(1)
    sd = rand(5.0..20.0).round(1)
    threshold = (mean + rand(-10.0..10.0)).round(1)

    probability = upper_tail_probability(mean, sd, threshold)

    question_text = assembly_line_question_text(mean, sd, threshold)
    build_probability_problem(question_text, probability)
  end

  def generate_battery_lifespan_problem
    mean = rand(200.0..500.0).round(1)
    sd = rand(20.0..50.0).round(1)
    threshold = (mean + rand(-100.0..50.0)).round(1)

    probability = lower_tail_probability(mean, sd, threshold)

    question_text = battery_lifespan_question_text(mean, sd, threshold)
    build_probability_problem(question_text, probability)
  end

  def generate_customer_wait_time_problem
    mean = rand(5.0..20.0).round(1)
    sd = rand(1.0..5.0).round(1)
    lower_bound = (mean - rand(1.0..5.0)).round(1)
    upper_bound = (mean + rand(1.0..5.0)).round(1)

    probability = between_probability(mean, sd, lower_bound, upper_bound)

    question_text = customer_wait_time_question_text(mean, sd, lower_bound, upper_bound)
    build_probability_problem(question_text, probability)
  end

  def generate_package_weight_problem
    mean = rand(2.0..10.0).round(1)
    sd = rand(0.2..1.0).round(1)
    threshold = (mean + rand(0.5..2.0)).round(1)

    probability = upper_tail_probability(mean, sd, threshold)

    question_text = package_weight_question_text(mean, sd, threshold)
    build_probability_problem(question_text, probability)
  end

  def generate_exam_score_problem
    mean = rand(65.0..80.0).round(1)
    sd = rand(5.0..15.0).round(1)
    pass_score = rand(mean - 10.0..mean + 10.0).round(1)

    probability = upper_tail_probability(mean, sd, pass_score)

    question_text = exam_score_question_text(mean, sd, pass_score)
    build_probability_problem(question_text, probability)
  end

  def generate_component_lifetime_problem
    mean = rand(5000.0..10_000.0).round(1)
    sd = rand(500.0..1000.0).round(1)
    lower_bound = (mean - rand(1000.0..2000.0)).round(1)
    upper_bound = (mean + rand(1000.0..2000.0)).round(1)

    probability = between_probability(mean, sd, lower_bound, upper_bound)

    question_text = component_lifetime_question_text(mean, sd, lower_bound, upper_bound)
    build_probability_problem(question_text, probability)
  end

  def generate_medication_dosage_problem
    mean = rand(4.0..8.0).round(1)
    sd = rand(0.5..1.5).round(1)
    threshold = (mean - rand(0.5..2.0)).round(1)

    probability = upper_tail_probability(mean, sd, threshold)

    question_text = medication_dosage_question_text(mean, sd, threshold)
    build_probability_problem(question_text, probability)
  end
end
