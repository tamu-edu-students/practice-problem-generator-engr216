# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Seed the RottenPotatoes DB with some movies.
# Clear existing data

require 'faker'

Student.destroy_all
Teacher.destroy_all
Category.destroy_all

students = 50.times.map do
  Student.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    uin: Faker::Number.number(digits: 9)
  )
end


teachers = [
  { email: 'test_teacher@tamu.edu', first_name: 'test', last_name: 'teacher'},
  { email: 'kjs3767@tamu.edu', first_name: 'kevin', last_name: 'shi'},
  { email: 'n2rowc@tamu.edu', first_name: 'nicholas', last_name: 'tuorci'},
  { email: 'coopercalk@tamu.edu', first_name: 'cooper', last_name: 'calk'},
  { email: 'jordandary@tamu.edu', first_name: 'jordan', last_name: 'daryanani'},
  { email: 'vivek.somarapu@tamu.edu', first_name: 'vivek', last_name: 'somarapu'},
  { email: 'dhruvmanihar@tamu.edu', first_name: 'dhruv', last_name: 'manihar'}
]

# students.each do |student|
#   Student.create!(student)
# end

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

teachers.each do |teacher|
  Teacher.create!(teacher)
end

puts "Seeded #{Student.count} students!"
puts "Seeded #{Teacher.count} teachers!"
