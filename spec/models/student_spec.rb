require 'rails_helper'

RSpec.describe Student, type: :model do
  let(:teacher) { Teacher.create!(name: 'Test Teacher', email: "teacher_#{Time.now.to_i}@example.com") }
  let(:semester) { Semester.create!(name: "Test Semester #{Time.now.to_i}", active: true) }

  describe 'validations' do
    it 'is valid with all required attributes' do
      student = described_class.new(
        first_name: 'John',
        last_name: 'Doe',
        email: "john_#{Time.now.to_i}@example.com",
        uin: 123_456_789,
        teacher: teacher,
        semester: semester
      )
      expect(student).to be_valid
    end

    it 'is invalid without a first name' do
      student = described_class.new(
        last_name: 'Doe',
        email: "john_#{Time.now.to_i}@example.com",
        uin: 123_456_789,
        teacher: teacher,
        semester: semester
      )
      expect(student).not_to be_valid
      expect(student.errors[:first_name]).to include("can't be blank")
    end

    it 'is invalid without a last name' do
      student = described_class.new(
        first_name: 'John',
        email: "john_#{Time.now.to_i}@example.com",
        uin: 123_456_789,
        teacher: teacher,
        semester: semester
      )
      expect(student).not_to be_valid
      expect(student.errors[:last_name]).to include("can't be blank")
    end

    it 'is invalid without an email' do
      student = described_class.new(
        first_name: 'John',
        last_name: 'Doe',
        uin: 123_456_789,
        teacher: teacher,
        semester: semester
      )
      expect(student).not_to be_valid
      expect(student.errors[:email]).to include("can't be blank")
    end

    it 'is invalid without a UIN' do
      student = described_class.new(
        first_name: 'John',
        last_name: 'Doe',
        email: "john_#{Time.now.to_i}@example.com",
        teacher: teacher,
        semester: semester
      )
      expect(student).not_to be_valid
      expect(student.errors[:uin]).to include("can't be blank")
    end

    it 'is invalid with a duplicate email' do
      unique_email = "john_#{Time.now.to_i}@example.com"

      described_class.create!(
        first_name: 'John',
        last_name: 'Doe',
        email: unique_email,
        uin: 123_456_789,
        teacher: teacher,
        semester: semester
      )

      student = described_class.new(
        first_name: 'Jane',
        last_name: 'Doe',
        email: unique_email,
        uin: 987_654_321,
        teacher: teacher,
        semester: semester
      )

      expect(student).not_to be_valid
      expect(student.errors[:email]).to include('has already been taken')
    end

    it 'is invalid with a UIN that is not 9 digits' do
      student = described_class.new(
        first_name: 'John',
        last_name: 'Doe',
        email: "john_#{Time.now.to_i}@example.com",
        uin: 12_345,
        teacher: teacher,
        semester: semester
      )
      expect(student).not_to be_valid
      expect(student.errors[:uin]).to include('is the wrong length (should be 9 characters)')
    end
  end

  describe 'associations' do
    it 'belongs to a teacher (optional)' do
      association = described_class.reflect_on_association(:teacher)
      expect(association.macro).to eq(:belongs_to)
      expect(association.options[:optional]).to be(true)
    end

    it 'belongs to a semester (optional)' do
      association = described_class.reflect_on_association(:semester)
      expect(association.macro).to eq(:belongs_to)
      expect(association.options[:optional]).to be(true)
    end
  end

  describe 'scopes' do
    it 'filters students by semester' do
      fall_semester = Semester.create!(name: "Fall #{Time.now.to_i}", active: true)
      spring_semester = Semester.create!(name: "Spring #{Time.now.to_i}", active: true)

      student1 = described_class.create!(
        first_name: 'John',
        last_name: 'Doe',
        email: "john_#{Time.now.to_i}@example.com",
        uin: 123_456_789,
        teacher: teacher,
        semester: fall_semester
      )

      student2 = described_class.create!(
        first_name: 'Jane',
        last_name: 'Smith',
        email: "jane_#{Time.now.to_i}@example.com",
        uin: 987_654_321,
        teacher: teacher,
        semester: spring_semester
      )

      expect(described_class.by_semester(fall_semester.id)).to include(student1)
      expect(described_class.by_semester(fall_semester.id)).not_to include(student2)
      expect(described_class.by_semester(spring_semester.id)).to include(student2)
      expect(described_class.by_semester(spring_semester.id)).not_to include(student1)
    end

    it 'returns all students when no semester is specified' do
      student = described_class.create!(
        first_name: 'John',
        last_name: 'Doe',
        email: "john_#{Time.now.to_i}@example.com",
        uin: 123_456_789,
        teacher: teacher,
        semester: semester
      )

      expect(described_class.by_semester(nil)).to include(student)
    end
  end
end
