require 'faker'

# Clear existing data for Students, Teachers, Questions, and Answers
Semester.destroy_all
Student.destroy_all
Teacher.destroy_all
Question.destroy_all
Answer.destroy_all

# Reset SQLite autoincrement during testing in development
case ActiveRecord::Base.connection.adapter_name
when 'SQLite'
  %w[students teachers questions answers].each do |t|
    ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='#{t}'")
  end
when 'PostgreSQL'
  %w[students teachers questions answers].each do |t|
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{t} RESTART IDENTITY CASCADE")
  end
end

# Seed Semesters
semesters_data = [
  { name: 'Spring 2023', active: false },
  { name: 'Fall 2023', active: false },
  { name: 'Spring 2024', active: true },
  { name: 'Summer 2024', active: true },
  { name: 'Fall 2024', active: true },
  { name: 'Spring 2025', active: true }
]

semesters = semesters_data.map do |semester_data|
  Semester.create!(semester_data)
end

# Seed Teachers
teachers_data = [
  { email: 'kjs3767@tamu.edu', first_name: 'kevin', last_name: 'shi' },
  { email: 'n2rowc@tamu.edu', first_name: 'nicholas', last_name: 'turoci' },
  { email: 'coopercalk@tamu.edu', first_name: 'cooper', last_name: 'calk' },
  { email: 'jordandary@tamu.edu', first_name: 'jordan', last_name: 'daryanani' },
  { email: 'vivek.somarapu@tamu.edu', first_name: 'vivek', last_name: 'somarapu' },
  { email: 'dhruvmanihar@tamu.edu', first_name: 'dhruv', last_name: 'manihar' },
  { email: 'pcr@tamu.edu', first_name: 'philip', last_name: 'ritchey' },
  { email: 'susindar@tamu.edu', first_name: 'sahinya', last_name: 'susindar' }
]

teachers = teachers_data.map do |teacher_data|
  Teacher.find_or_create_by!(email: teacher_data[:email]) do |teacher|
    teacher.name = "#{teacher_data[:first_name].capitalize} #{teacher_data[:last_name].capitalize}"
  end
end

# Seed Students
200.times do
  assigned_teacher = teachers.sample
  assigned_semester = semesters.sample
  Student.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.unique.email,
    uin: Faker::Number.number(digits: 9).to_i,
    teacher: assigned_teacher,
    teacher_id: assigned_teacher.id,
    authenticate: true,
    semester: assigned_semester,
    semester_id: assigned_semester.id
  )
end
physics_categories = {
   'Measurement & Error' => [
     'What is the difference between systematic and random errors?',
     'How can precision and accuracy be distinguished in measurements?',
     'Describe methods to reduce measurement errors in experiments.'
   ],
   'Propagation of Error' => [
     'How do errors propagate in calculations involving addition and subtraction?',
     'Explain the formula for error propagation in multiplication and division of measured values.',
     'Provide an example of how error propagation can affect experimental outcomes.'
   ],
   'Finite Differences' => [
     'What is the finite difference method and how is it applied in numerical analysis?',
     'Compare forward, backward, and central differences in approximating derivatives.',
     'How can finite differences be used to solve differential equations numerically?'
   ],
   'Experimental Statistics' => [
     'What statistical methods are essential for analyzing experimental data?',
     'How do you determine if a dataset follows a normal distribution?',
     'Explain the impact of outliers on experimental statistics.'
   ],
   'Confidence Intervals' => [
     'What is a confidence interval and how is it interpreted in the context of experimental data?',
     'How do you calculate a confidence interval for a mean value?',
     'Discuss the factors that influence the width of a confidence interval.'
   ],
   'Universal Accounting Equation' => [
     'What is the universal accounting equation and how does it relate to financial analysis?',
     'Explain the relationship between assets, liabilities, and equity using the universal accounting equation.',
     'How can the universal accounting equation be applied to assess the financial stability of an engineering project?'
   ],
   'Particle Statics' => [
     'What is the principle of particle statics in mechanics?',
     'How do you analyze forces acting on a particle in equilibrium?',
     'Provide an example problem involving particle statics and its solution.'
   ],
   'Momentum & Collisions' => [
     'What is the law of conservation of momentum?',
     'How do elastic and inelastic collisions differ regarding momentum conservation?',
     'Describe how impulse relates to momentum in collision scenarios.'
   ],
   'Rigid Body Statics' => [
     'What are the conditions necessary for equilibrium in rigid body statics?',
     'Explain how to determine the center of gravity of a rigid body.',
     'How do you analyze torque in rigid body statics?'
   ],
   'Angular Momentum' => [
     'Define angular momentum and state the law of its conservation.',
     'How is angular momentum calculated for a rotating system?',
     "Discuss the effects of external torques on a system's angular momentum."
   ],
   'Harmonic Motion' => [
     'What defines simple harmonic motion?',
     'How do amplitude, frequency, and phase influence harmonic motion?',
     'Explain the energy transformations that occur in a system undergoing harmonic motion.'
   ],
   'Engineering Ethics' => [
     'Why is engineering ethics critical in professional practice?',
     'Discuss a real-world case where ethical considerations impacted an engineering decision.',
     'How can engineers balance innovation with ethical responsibilities?'
   ]
 }

 physics_categories.each do |category, questions|
  questions.each do |q_text|
    q = Question.create!(category: category, question: q_text)
    # Set the answer_choices attribute to an array
    q.write_attribute(:answer_choices, ['TBD'])
    q.save!
  end
end

#----------------------------------------------
# Dynamic Answer Seeding Using Generator Mapping
#----------------------------------------------

# Mapping function to select the appropriate problem generator based on category.
# Mapping function to select the appropriate problem generator based on category.
def generate_question_for(category)
  case category.downcase
  when /particle statics/
    ParticleStaticsProblemGenerator.new(category).generate_questions.first
  when /angular momentum/
    AngularMomentumProblemGenerator.new(category).generate_questions.first
  when /harmonic motion/
    HarmonicMotionProblemGenerator.new(category).generate_questions.first
  when /measurement & error/
    MeasurementsAndErrorProblemGenerator.new(category).generate_questions.first
  when /propagation of error/
    ErrorPropagationProblemGenerator.new(category).generate_questions.first
  when /rigid body statics/
    RigidBodyStaticsProblemGenerator.new(category).generate_questions.first
  when /finite differences/
    FiniteDifferencesProblemGenerator.new(category).generate_questions.first
  when /experimental statistics/
    StatisticsProblemGenerator.new(category).generate_questions.sample
  when /confidence intervals/
    ConfidenceIntervalProblemGenerator.new(category).generate_questions.first
  when /engineering ethics/
    EngineeringEthicsProblemGenerator.new(category).generate_questions.first
  when /momentum & collisions/
    CollisionProblemGenerator.new(category).generate_questions.first
  when /universal accounting equation/
    UniversalAccountEquationsProblemGenerator.new(category).generate_questions.first
  else
    # Fallback to a generic problem generator if none of the above match.
    ProblemGenerator.new(category).generate_questions.first
  end
end

# Define the complete list of categories based on your application's distinct entries.
categories = [
  "Angular Momentum",
  "Confidence Intervals",
  "Engineering Ethics",
  "Experimental Statistics",
  "Finite Differences",
  "Harmonic Motion",
  "Measurement & Error",
  "Momentum & Collisions",
  "Particle Statics",
  "Propagation of Error",
  "Rigid Body Statics",
  "Universal Accounting Equation"
]

# Loop over each student and each category.
Student.find_each do |student|
  categories.each do |category|
    # Generate 10-20 questions per category for each student.
    rand(0..20).times do
      generated_question = generate_question_for(category)
      # Skip if no valid question is generated.
      next unless generated_question && generated_question[:question].present?
      
      # Create an Answer record using the generated question details.
      Answer.create!(
        template_id: generated_question[:template_id] || 0,
        question_id: nil,  # Adjust if you have corresponding Question records.
        category: category,
        question_description: generated_question[:question],
        answer_choices: (generated_question[:answer_choices] || ['TBD']).to_json,
        answer: 'Seeded Answer',       # New placeholder answer text.
        correctness: rand < 0.5,       # Randomly assigns true or false.
        student_email: student.email,
        date_completed: Faker::Date.backward(days: 30),
        time_spent: "#{rand(1..10)} minutes"
      )
    end
  end
end


Rails.logger.debug { "Seeded #{Student.count} students!" }
Rails.logger.debug { "Seeded #{Teacher.count} teachers!" }
Rails.logger.debug { "Seeded #{Question.count} questions!" }
Rails.logger.debug { "Seeded #{Answer.count} answers!" }
Rails.logger.debug { "Seeded #{Semester.count} semesters!" }