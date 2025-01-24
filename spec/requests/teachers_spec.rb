require 'rails_helper'

RSpec.describe "Teachers", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/teachers/show"
      expect(response).to have_http_status(:success)
    end
  end

end
