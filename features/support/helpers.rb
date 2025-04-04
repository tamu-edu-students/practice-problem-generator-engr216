def login_as_student
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
    uid: '123',
    provider: 'google_oauth2',
    info: {
      email: 'test_student@tamu.edu',
      first_name: 'Test',
      last_name: 'Student'
    }
  )
  visit '/auth/google_oauth2/callback?state=student'
end

def store_page_content
  @previous_page_content = page.body
end
