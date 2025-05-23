Rails.logger.debug 'OmniAuth initializer loaded' # for cucumber test debugging
require 'omniauth'
require 'omniauth-google-oauth2'

Rails.application.config.middleware.use OmniAuth::Builder do
  # Retrieve the Google credentials from environment variables
  google_client_id = ENV['GOOGLE_CLIENT_ID'] || 'dummy_client_id'
  google_client_secret = ENV['GOOGLE_CLIENT_SECRET'] || 'dummy_client_secret'

  # Configure the Google OAuth provider with the client_id and client_secret
  provider :google_oauth2, google_client_id, google_client_secret, {
    scope: 'email, profile',  # This grants access to the user's email and profile information.
    prompt: 'select_account', # This allows users to choose the account they want to log in with.
    image_aspect_ratio: 'square', # Ensures the profile picture is a square.
    image_size: 50 # Sets the profile picture size to 50x50 pixels.
  }
end
