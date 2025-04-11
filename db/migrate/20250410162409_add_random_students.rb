require 'faker'

class AddRandomStudents < ActiveRecord::Migration[7.1]
  def up
    # Make sure we have semesters to assign to students
    semesters = ['Spring 2024', 'Fall 2023', 'Summer 2023', 'Spring 2023']
    semester_ids = []
    
    semesters.each do |name|
      semester = Semester.find_by(name: name)
      unless semester
        semester = Semester.create(name: name, is_active: true)
      end
      semester_ids << semester.id
    end
    
    # Get all teachers
    teachers = Teacher.all
    return if teachers.empty?
    
    # Add a special test student with UIN 100_000_000
    unless Student.exists?(uin: 100_000_000)
      teacher = teachers.sample
      Student.create!(
        email: "test_special@tamu.edu",
        name: "Special Test Student",
        uin: 100_000_000,
        teacher_id: teacher.id,
        semester_id: nil, # No semester assigned, to trigger the prompt
        created_at: Time.current,
        updated_at: Time.current
      )
    end
    
    # Add 50 random students
    50.times do |i|
      email = "test_student#{i+1}@tamu.edu"
      
      # Skip if student with this email already exists
      next if Student.exists?(email: email)
      
      # Pick a random semester and teacher
      semester_id = semester_ids.sample
      teacher = teachers.sample
      
      # Create student
      Student.create!(
        email: email,
        name: Faker::Name.name,
        uin: 100_000_001 + i,
        teacher_id: teacher.id,
        semester_id: semester_id,
        created_at: Time.current,
        updated_at: Time.current
      )
    end
  end

  def down
    # Nothing to do
  end
end
