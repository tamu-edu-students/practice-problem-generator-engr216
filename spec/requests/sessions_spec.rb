require 'rails_helper'

describe 'GET /omniauth' do
  before do
    OmniAuth.config.mock_auth[:google_oauth2] = mock_auth_hash('test_student@tamu.edu')
  end

  it 'redirects to the appropriate path' do
    get '/auth/google_oauth2/callback'
    expect(response).to redirect_to(root_path)
  end
end
