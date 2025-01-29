# spec/controllers/sessions_controller_spec.rb
require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'GET #omniauth' do
    let(:auth) { OmniAuth.config.mock_auth[:google_oauth2] }

    context 'when state is teacher' do
      before do
        OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
                                                                             uid: '123',
                                                                             provider: 'google_oauth2',
                                                                             info: { email: 'teacher@example.com',
                                                                                     name: 'Teacher Name' }
                                                                           })
      end

      it 'redirects to teachers_path with a notice' do
        get :omniauth, params: { state: 'teacher' }

        expect(response).to redirect_to(teachers_path)
        expect(flash[:notice]).to eq('You are logged in as a teacher.')
      end
    end

    context 'when state is student' do
      before do
        OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
                                                                             uid: '456',
                                                                             provider: 'google_oauth2',
                                                                             info: { name: 'Student Name' }
                                                                           })
      end

      it 'redirects to students_path with a notice' do
        get :omniauth, params: { state: 'student' }

        expect(response).to redirect_to(students_path)
        expect(flash[:notice]).to eq('You are logged in as a student.')
      end
    end

    context 'when state is invalid' do
      it 'redirects to root_path with an alert' do
        get :omniauth, params: { state: 'invalid_state' }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Invalid user type.')
      end
    end
  end
end
