# features/support/omniauth.rb
OmniAuth.config.test_mode = true

# Define a mock auth hash for your provider (e.g., Google)
OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
  provider: 'google_oauth2',
  uid: '12345',
  info: {
    email: 'kjs3767@tamu.edu',
    name: 'Test Teacher Kevin'
  }
})

