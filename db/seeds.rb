require 'faker'

# Clear existing data for Students, Teachers, and Questions
Student.destroy_all
Teacher.destroy_all
Question.destroy_all
Answer.destroy_all


# # Reset SQLite autoincrement
# ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='students'")
# ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='teachers'")
# ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='questions'")
# ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='answers'")

# Seed Teachers
teachers_data = [
  { email: 'test_teacher@tamu.edu', first_name: 'test', last_name: 'teacher' },
  { email: 'kjs3767@tamu.edu', first_name: 'kevin', last_name: 'shi' },
  { email: 'n2rowc@tamu.edu', first_name: 'nicholas', last_name: 'tuorci' },
  { email: 'coopercalk@tamu.edu', first_name: 'cooper', last_name: 'calk' },
  { email: 'jordandary@tamu.edu', first_name: 'jordan', last_name: 'daryanani' },
  { email: 'vivek.somarapu@tamu.edu', first_name: 'vivek', last_name: 'somarapu' },
  { email: 'dhruvmanihar@tamu.edu', first_name: 'dhruv', last_name: 'manihar' }
]

teachers = teachers_data.map do |teacher_data|
  Teacher.create!(
    name: "#{teacher_data[:first_name].capitalize} #{teacher_data[:last_name].capitalize}",
    email: teacher_data[:email]
  )
end

# Seed Students
50.times do
  assigned_teacher = teachers.sample
  Student.create!(
    first_name: Faker::Name.first_name,
    last_name:  Faker::Name.last_name,
    email:      Faker::Internet.email,
    uin:        Faker::Number.number(digits: 9).to_i,
    teacher:    assigned_teacher,  # associating the teacher object
    teacher_id: assigned_teacher.id,
    authenticate: [true, false].sample
  )
end

physics_categories = {
  "Measurement & Error" => [
    "What is the difference between systematic and random errors?",
    "How can precision and accuracy be distinguished in measurements?",
    "Describe methods to reduce measurement errors in experiments."
  ],
  "Propagation of Error" => [
    "How do errors propagate in calculations involving addition and subtraction?",
    "Explain the formula for error propagation in multiplication and division of measured values.",
    "Provide an example of how error propagation can affect experimental outcomes."
  ],
  "Finite Differences" => [
    "What is the finite difference method and how is it applied in numerical analysis?",
    "Compare forward, backward, and central differences in approximating derivatives.",
    "How can finite differences be used to solve differential equations numerically?"
  ],
  "Experimental Statistics" => [
    "What statistical methods are essential for analyzing experimental data?",
    "How do you determine if a dataset follows a normal distribution?",
    "Explain the impact of outliers on experimental statistics."
  ],
  "Confidence Intervals" => [
    "What is a confidence interval and how is it interpreted in the context of experimental data?",
    "How do you calculate a confidence interval for a mean value?",
    "Discuss the factors that influence the width of a confidence interval."
  ],
  "Universal Accounting Equation" => [
    "What is the universal accounting equation and how does it relate to financial analysis?",
    "Explain the relationship between assets, liabilities, and equity using the universal accounting equation.",
    "How can the universal accounting equation be applied to assess the financial stability of an engineering project?"
  ],
  "Particle Statics" => [
    "What is the principle of particle statics in mechanics?",
    "How do you analyze forces acting on a particle in equilibrium?",
    "Provide an example problem involving particle statics and its solution."
  ],
  "Momentum & Collisions" => [
    "What is the law of conservation of momentum?",
    "How do elastic and inelastic collisions differ regarding momentum conservation?",
    "Describe how impulse relates to momentum in collision scenarios."
  ],
  "Rigid Body Statics" => [
    "What are the conditions necessary for equilibrium in rigid body statics?",
    "Explain how to determine the center of gravity of a rigid body.",
    "How do you analyze torque in rigid body statics?"
  ],
  "Angular Momentum" => [
    "Define angular momentum and state the law of its conservation.",
    "How is angular momentum calculated for a rotating system?",
    "Discuss the effects of external torques on a system's angular momentum."
  ],
  "Harmonic Motion" => [
    "What defines simple harmonic motion?",
    "How do amplitude, frequency, and phase influence harmonic motion?",
    "Explain the energy transformations that occur in a system undergoing harmonic motion."
  ],
  "Engineering Ethics" => [
    "Why is engineering ethics critical in professional practice?",
    "Discuss a real-world case where ethical considerations impacted an engineering decision.",
    "How can engineers balance innovation with ethical responsibilities?"
  ],
  "Art in Engineering" => [
    "How does art influence design in engineering projects?",
    "In what ways can engineering principles enhance artistic expression?",
    "Discuss examples where art and engineering have successfully integrated."
  ]
}

physics_categories.each do |category, questions|
  questions.each do |q_text|
    q = Question.create!(category: category, question: q_text)
    # Set the answer_choices attribute to an array
    q.write_attribute(:answer_choices, ["TBD"])
    q.save!
  end
end

# Seed Answers for Each Student
Student.all.each do |student|
  Question.all.sample(rand(10..20)).each do |question| # 10-20 random questions per student
    Answer.create!(
      question_id: question.id,
      category: question.category,
      question_description: question.question,
      answer_choices: question.answer_choices,
      answer: "TBD", # Placeholder
      correctness: [true, false].sample,
      student_email: student.email,
      date_completed: Faker::Date.backward(days: 30),
      time_spent: "#{rand(1..10)} minutes"
    )
  end
end

puts "Seeded #{Student.count} students!"
puts "Seeded #{Teacher.count} teachers!"
puts "Seeded #{Question.count} questions!"
puts "Seeded #{Answer.count} answers!"
