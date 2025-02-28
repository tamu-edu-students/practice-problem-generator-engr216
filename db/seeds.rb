require 'faker'

# Clear existing data
Teacher.destroy_all
Student.destroy_all
Category.destroy_all

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

teachers = teachers_data.map do |data|
  Teacher.create!(
    name: "#{data[:first_name].capitalize} #{data[:last_name].capitalize}",
    email: data[:email]
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
    teacher:    assigned_teacher.name,   # storing teacher's name as string
    teacher_id: assigned_teacher.id,       # association
    authenticate: [true, false].sample
  )
end

# Seed Categories
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

puts "Seeded #{Teacher.count} teachers!"
puts "Seeded #{Student.count} students!"
puts "Seeded #{Category.count} categories!"
