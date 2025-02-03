# features/support/omniauth.rb
OmniAuth.config.test_mode = true

# Define a mock auth hash for your provider (e.g., Google)
OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
                                                                     provider: 'google_oauth2',
                                                                     uid: '12345',
                                                                     info: {
                                                                       email: 'test_teacher@tamu.edu',
                                                                       first_name: 'test',
                                                                       last_name: 'teacher'
                                                                     }
                                                                   })
