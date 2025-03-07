# spec/features/student_select_teacher_spec.rb

require 'rails_helper'

RSpec.feature 'Settings Teacher Dropdown', type: :feature do
  scenario 'Student sees teacher dropdown on settings page' do
    # Setup: Create a teacher in the database (optional if you just want to verify the dropdown exists)
    Teacher.create!(name: 'Test Teacher', email: 'test_teacher@example.com')

    # Visit the settings page (adjust the path if needed)
    visit '/settings'

    # Check that a select element with the name 'teacher' is present
    expect(page).to have_selector("select[name='teacher']")
  end
end
