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
Student.destroy_all
Teacher.destroy_all
# Sample students
students = [
  { first_name: 'John', last_name: 'Doe', uin: '123456789' },
  { first_name: 'Jane', last_name: 'Smith', uin: '987654321' },
  { first_name: 'Alice', last_name: 'Johnson', uin: '567890123' },
  { first_name: 'Bob', last_name: 'Brown', uin: '345678901' },
  { first_name: 'Charlie', last_name: 'Davis', uin: '234567890' }
]

teachers = [
  { email: 'kjs3767@tamu.edu', first_name: 'kevin', last_name: 'shi'},
  { email: 'n2rowc@tamu.edu', first_name: 'nicholas', last_name: 'tuorci'},
  { email: 'coopercalk@tamu.edu', first_name: 'cooper', last_name: 'calk'},
  { email: 'jordandary@tamu.edu', first_name: 'jordan', last_name: 'daryanani'},
  { email: 'vivek.somarapu@tamu.edu', first_name: 'vivek', last_name: 'somarpu'},
  { email: 'dhruvmanihar@tamu.edu', first_name: 'dhurv', last_name: 'manihar'}
]

students.each do |student|
  Student.create!(student)
end

teachers.each do |teacher|
  Teacher.create!(teacher)
end

Category.create([{ name: "Mechanics" }, { name: "Thermodynamics" }, { name: "Electromagnetism" }])

puts "Seeded #{Student.count} students!"
