require 'rails_helper'

RSpec.feature 'Teacher login with various emails', type: :feature do
  before do
    Teacher.find_or_create_by!(email: 'test_teacher@tamu.edu') do |teacher|
      teacher.first_name = 'test'
      teacher.last_name  = 'teacher'
    end
  end

  # Helper to perform teacher login using OmniAuth mock
  def perform_teacher_login(email:, first_name:, last_name:)
    OmniAuth.config.mock_auth[:google_oauth2] =
      OmniAuth::AuthHash.new(provider: 'google_oauth2',
                             info: { email: email, first_name: first_name,
                                     last_name: last_name })
    visit login_path
    visit '/auth/google_oauth2/callback?state=teacher'
  end

  scenario 'User attempts teacher login with a non-existent email and sees login failure' do
    perform_teacher_login(email: 'not_a_teacher@tamu.edu', first_name: 'not', last_name: 'teacher')

    aggregate_failures 'login failure expectations' do
      expect(page).to have_content('Login')
      expect(page).not_to have_content('Teacher Dashboard')
    end
  end

  scenario 'User attempts teacher login with a teacher email and sees teacher dashboard' do
    perform_teacher_login(email: 'test_teacher@tamu.edu', first_name: 'test', last_name: 'teacher')

    expect(page).to have_content('Teacher Dashboard')
  end
end
