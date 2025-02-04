require 'rails_helper'

RSpec.describe 'Settings', type: :request do
  describe 'GET /show' do
    it 'returns http success' do
      get '/settings'
      expect(response).to have_http_status(:success)
    end
  end
end
