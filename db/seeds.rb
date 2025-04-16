require 'faker'

# Clear existing data for Students, Teachers, Questions, and Answers
# Semester.destroy_all
# Student.destroy_all
# Teacher.destroy_all
# Question.destroy_all
# Answer.destroy_all

# # Reset SQLite autoincrement during testing in development
# ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='students'")
# ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='teachers'")
# ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='questions'")
# ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='answers'")

# Seed Semesters
# semesters_data = [
#   { name: 'Spring 2023', active: false },
#   { name: 'Fall 2023', active: false },
#   { name: 'Spring 2024', active: true },
#   { name: 'Summer 2024', active: true },
#   { name: 'Fall 2024', active: true },
#   { name: 'Spring 2025', active: true }
# ]

# semesters = semesters_data.map do |semester_data|
#   Semester.create!(semester_data)
# end

# # Seed Teachers
# teachers_data = [
#   { email: 'test_teacher@tamu.edu', first_name: 'test', last_name: 'teacher' },
#   { email: 'kjs3767@tamu.edu', first_name: 'kevin', last_name: 'shi' },
#   { email: 'n2rowc@tamu.edu', first_name: 'nicholas', last_name: 'tuorci' },
#   { email: 'coopercalk@tamu.edu', first_name: 'cooper', last_name: 'calk' },
#   { email: 'jordandary@tamu.edu', first_name: 'jordan', last_name: 'daryanani' },
#   { email: 'vivek.somarapu@tamu.edu', first_name: 'vivek', last_name: 'somarapu' },
#   { email: 'dhruvmanihar@tamu.edu', first_name: 'dhruv', last_name: 'manihar' }
# ]

# teachers = teachers_data.map do |teacher_data|
#   Teacher.find_or_create_by!(email: teacher_data[:email]) do |teacher|
#     teacher.name = "#{teacher_data[:first_name].capitalize} #{teacher_data[:last_name].capitalize}"
#   end
# end

# # Seed Students
# 200.times do
#   assigned_teacher = teachers.sample
#   assigned_semester = semesters.sample
#   Student.create!(
#     first_name: Faker::Name.first_name,
#     last_name: Faker::Name.last_name,
#     email: Faker::Internet.unique.email,
#     uin: Faker::Number.number(digits: 9).to_i,
#     teacher: assigned_teacher,
#     teacher_id: assigned_teacher.id,
#     authenticate: [true, false].sample,
#     semester: assigned_semester,
#     semester_id: assigned_semester.id
#   )
# end

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
    rand(10..20).times do
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
        answer: 'test answer',       # New placeholder answer text.
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
