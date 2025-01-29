require 'rails_helper'

describe 'GET /omniauth' do
  it 'redirects to the appropriate path' do
    get '/auth/google_oauth2/callback', params: { state: 'teacher' }
    expect(response).to redirect_to(teachers_path)
  end
end
