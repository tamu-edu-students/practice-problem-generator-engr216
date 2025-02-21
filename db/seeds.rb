# db/seeds.rb

require 'faker'

# Clear existing data
StudentCategoryStatistic.destroy_all
Student.destroy_all
Teacher.destroy_all
Category.destroy_all

# Create 50 students with a random section number (as a string) between 900 and 905
students = 50.times.map do
  Student.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    uin: Faker::Number.number(digits: 9),
    section: rand(900..905).to_s
  )
end

# Seed teachers
teachers = [
  { email: 'test_teacher@tamu.edu', first_name: 'test', last_name: 'teacher'},
  { email: 'kjs3767@tamu.edu', first_name: 'kevin', last_name: 'shi'},
  { email: 'n2rowc@tamu.edu', first_name: 'nicholas', last_name: 'tuorci'},
  { email: 'coopercalk@tamu.edu', first_name: 'cooper', last_name: 'calk'},
  { email: 'jordandary@tamu.edu', first_name: 'jordan', last_name: 'daryanani'},
  { email: 'vivek.somarapu@tamu.edu', first_name: 'vivek', last_name: 'somarapu'},
  { email: 'dhruvmanihar@tamu.edu', first_name: 'dhruv', last_name: 'manihar'}
]

teachers.each do |teacher_attrs|
  Teacher.create!(teacher_attrs)
end

# Seed categories
category_names = [
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

category_names.each do |name|
  Category.find_or_create_by!(name: name)
end

# Create dummy statistics for each student for every category
students.each do |student|
  Category.all.each do |category|
    attempts = rand(5..20)
    correct_attempts = rand(0..attempts)
    StudentCategoryStatistic.create!(
      student: student,
      category: category,
      attempts: attempts,
      correct_attempts: correct_attempts
    )
  end
end

puts "Seeded #{Student.count} students!"
puts "Seeded #{Teacher.count} teachers!"
puts "Seeded #{Category.count} categories!"
puts "Seeded #{StudentCategoryStatistic.count} student category statistics records!"
