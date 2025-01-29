require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'GET /logout' do
    it 'returns http success' do
      get '/sessions/logout'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /omniauth' do
    it 'returns http success' do
      get '/sessions/omniauth'
      expect(response).to have_http_status(:success)
    end
  end
end
