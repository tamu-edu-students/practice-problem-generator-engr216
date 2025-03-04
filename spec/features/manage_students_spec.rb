require 'rails_helper'

RSpec.feature 'Manage Students', type: :feature do
  before do
    Teacher.find_or_create_by!(email: 'test_teacher@tamu.edu') do |teacher|
      teacher.name = 'Test Teacher'
    end
  end

  def perform_teacher_login(email:, first_name:, last_name:)
    OmniAuth.config.mock_auth[:google_oauth2] =
      OmniAuth::AuthHash.new(provider: 'google_oauth2',
                             info: { email: email, first_name: first_name,
                                     last_name: last_name })
    visit login_path
    visit '/auth/google_oauth2/callback?state=teacher'
  end

  scenario 'Teacher sees Manage Student page' do
    perform_teacher_login(email: 'test_teacher@tamu.edu', first_name: 'test', last_name: 'teacher')
    visit '/teacher_dashboard/manage_students'

    expect(page).to have_selector('h1', text: 'Manage Students')
  end

  scenario 'Teacher sees a list of students' do
    perform_teacher_login(email: 'test_teacher@tamu.edu', first_name: 'test', last_name: 'teacher')
    Student.find_or_create_by!(first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com', uin: 123_456_789)
    visit '/teacher_dashboard/manage_students'

    expect(page).to have_content('John Doe')
  end
end
