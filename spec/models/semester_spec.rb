require 'rails_helper'

RSpec.describe Semester, type: :model do
  include ActiveSupport::Testing::TimeHelpers

  describe 'validations' do
    it 'is valid with a name' do
      semester = described_class.new(name: 'Fall 2024 Test 1', active: true)
      expect(semester).to be_valid
    end

    it 'is invalid without a name' do
      semester = described_class.new(active: true)
      expect(semester).not_to be_valid
      expect(semester.errors[:name]).to include("can't be blank")
    end

    it 'is invalid with a duplicate name' do
      described_class.create!(name: 'Fall 2024 Test 2', active: true)
      semester = described_class.new(name: 'Fall 2024 Test 2', active: false)
      expect(semester).not_to be_valid
      expect(semester.errors[:name]).to include('has already been taken')
    end
  end

  describe 'associations' do
    it 'has many students' do
      semester = described_class.reflect_on_association(:students)
      expect(semester.macro).to eq(:has_many)
    end

    context 'when destroyed' do
      let(:semester) { described_class.create!(name: 'Fall 2024 Test 3', active: true) }
      let(:teacher) { Teacher.create!(name: 'Test Teacher', email: 'teacher_test3@tamu.edu') }
      let(:student) do
        Student.create!(
          first_name: 'John',
          last_name: 'Doe',
          email: 'john_test3@example.com',
          uin: 123_456_789,
          teacher: teacher,
          semester: semester
        )
      end

      it 'nullifies associated students' do
        student # Ensure student is created
        expect { semester.destroy }.to change { Student.find(student.id).semester }.from(semester).to(nil)
      end
    end
  end

  describe 'scopes' do
    it 'active returns only active semesters' do
      active_semester = described_class.create!(name: 'Fall 2024 Test 4', active: true)
      inactive_semester = described_class.create!(name: 'Spring 2023 Test 4', active: false)

      expect(described_class.active).to include(active_semester)
      expect(described_class.active).not_to include(inactive_semester)
    end
  end

  describe '.current' do
    it 'returns the most recent active semester' do
      # Make sure all existing semesters are inactive first
      described_class.where(active: true).find_each { |semester| semester.update(active: false) }

      # Create two new active semesters with specific creation times
      older = described_class.create!(name: "Spring 2024 Test #{Time.now.to_i}", active: true)
      travel_to(2.days.ago) do
        older.save # Save with older timestamp
      end

      newer = described_class.create!(name: "Fall 2024 Test #{Time.now.to_i}", active: true)
      travel_to(1.day.ago) do
        newer.save # Save with newer timestamp
      end

      expect(described_class.current).to eq(newer)
    end

    it 'returns nil when no active semesters exist' do
      # Make sure there are no active semesters in the database
      described_class.where(active: true).find_each { |semester| semester.update(active: false) }
      described_class.create!(name: 'Spring 2024 Test 6', active: false)
      expect(described_class.current).to be_nil
    end
  end
end
