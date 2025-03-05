require 'faker'

# Clear existing data for Students, Teachers, and Questions
Student.destroy_all
Teacher.destroy_all
Question.destroy_all

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
    authenticate: [true, false].sample
  )
end

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

puts "Seeded #{Student.count} students!"
puts "Seeded #{Teacher.count} teachers!"
puts "Seeded #{Question.count} questions!"
