require 'faker'

# Clear existing data for Students, Teachers, and Questions
Student.destroy_all
Teacher.destroy_all
<<<<<<< HEAD
Category.destroy_all
StudentCategoryStatistic.destroy_all
# Answer.destroy_all
# Question.destroy_all
=======
Question.destroy_all
>>>>>>> main

# Reset the AUTOINCREMENT counter for SQLite
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='students'")
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='teachers'")
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='categories'")
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='student_category_statistics'")

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

# Helper to create a student, Currently utilized by student statistics page
def create_student(teacher)
  Student.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    uin: Faker::Number.number(digits: 9).to_i,
    teacher: teacher,
    authenticate: [true, false].sample
  )
end

teachers.each do |teacher|
  rand(1..3).times { create_student(teacher) } # Each gets 1-3 students
end

# Distribute remaining students to reach ~50 total
remaining_students = 50 - Student.count
remaining_students.times { create_student(teachers.sample) } if remaining_students > 0



# Comment out or remove the following if you don't want to seed Questions and Answers now:
=begin
5.times do
  question = Question.create!(
    category: Faker::Educator.subject,
    question: Faker::Lorem.sentence,
    answers: Faker::Lorem.sentence
  )
# Seed Questions (Physics)
physics_categories = {
  "Mechanics" => [
    "What is Newton's Second Law of Motion?",
    "Calculate the net force on a 10 kg object accelerating at 3 m/s².",
    "Define friction and provide an example in everyday life."
  ],
  "Thermodynamics" => [
    "State the First Law of Thermodynamics.",
    "What is entropy and why is it important?",
    "How does a heat engine convert thermal energy into work?"
  ],
  "Electromagnetism" => [
    "What does Coulomb's Law state about the force between charges?",
    "Describe the phenomenon of electromagnetic induction.",
    "How do electric and magnetic fields interact in electromagnetic waves?"
  ],
  "Optics" => [
    "Explain Snell's Law and its relation to refraction.",
    "How does a convex lens form an image?",
    "What causes the dispersion of light in a prism?"
  ],
  "Quantum Mechanics" => [
    "What is wave-particle duality?",
    "State the Heisenberg Uncertainty Principle.",
    "How does the Schrödinger equation describe quantum states?"
  ],
  "Relativity" => [
    "What is time dilation in special relativity?",
    "Explain the equivalence principle in general relativity.",
    "Interpret the meaning of E=mc²."
  ],
  "Acoustics" => [
    "How is sound intensity measured?",
    "What is the Doppler Effect and how does it affect sound?",
    "Explain how sound waves propagate through different mediums."
  ],
  "Nuclear Physics" => [
    "What is nuclear fission and how is it harnessed for energy?",
    "Describe the process of nuclear fusion in stars.",
    "How does radioactive decay occur?"
  ],
  "Astrophysics" => [
    "What defines a black hole?",
    "Explain the lifecycle of a star from birth to death.",
    "How do astronomers measure distances to galaxies?"
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

categories = [
  'Measurement & Error',
  'Propagation of Error',
  'Finite Differences',
  'Experimental Statistics',
  'Confidence Intervals',
  'Universal Accounting Equation',
  'Particle Statics',
  'Momentum & Collisions',
  'Rigid Body Statics',
  'Angular Momentum',
  'Harmonic Motion',
  'Engineering Ethics',
  'Art in Engineering'
]

categories.each do |name|
  Category.find_or_create_by!(name: name)
end

# Seed Student Category Statistics
Student.all.each do |student|
  # Randomly select 2-5 categories for each student to have stats in
  student_categories = Category.all.sample(rand(2..5))
  student_categories.each do |category|
    attempts = rand(1..10) # Random number of attempts between 1 and 10
    correct_attempts = rand(0..attempts) # Correct attempts can't exceed total attempts
    StudentCategoryStatistic.create!(
      student_id: student.id,
      category_id: category.id,
      attempts: attempts,
      correct_attempts: correct_attempts
    )
  end
end

puts "Seeded #{Category.count} categories!"

puts "Seeded #{Student.count} students!"
puts "Seeded #{Teacher.count} teachers!"
<<<<<<< HEAD
puts "Seeded #{StudentCategoryStatistic.count} student category statistics!"
# puts "Seeded #{Question.count} questions!"
# puts "Seeded #{Answer.count} answers!"
=======
puts "Seeded #{Question.count} questions!"
>>>>>>> main
