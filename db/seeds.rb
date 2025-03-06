require 'faker'

# Clear existing data for Students and Teachers (and others if needed)
Student.destroy_all
Teacher.destroy_all
# Answer.destroy_all
# Question.destroy_all

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

# Comment out or remove the following if you don't want to seed Questions and Answers now:
=begin
5.times do
  question = Question.create!(
    category: Faker::Educator.subject,
    question: Faker::Lorem.sentence,
    answers: Faker::Lorem.sentence
  )

  3.times do
    Answer.create!(
      question_id: question.id,
      category: question.category,
      question_description: Faker::Lorem.paragraph,
      answer_choices: [Faker::Lorem.word, Faker::Lorem.word, Faker::Lorem.word],
      answer: Faker::Lorem.word,
      correctness: [true, false].sample,
      student_email: Faker::Internet.email,
      date_completed: Date.today.to_s,
      time_spent: "#{rand(5..30)} seconds"
    )
  end
end
=end

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

puts "Seeded #{Category.count} categories!"

puts "Seeded #{Student.count} students!"
puts "Seeded #{Teacher.count} teachers!"
# puts "Seeded #{Question.count} questions!"
# puts "Seeded #{Answer.count} answers!"
