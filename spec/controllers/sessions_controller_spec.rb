# spec/controllers/sessions_controller_spec.rb
require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'GET #omniauth' do
    before do
      # Ensure the teacher exists (using new Teacher attributes)
      Teacher.find_or_create_by!(email: 'test_teacher@tamu.edu') do |t|
        t.name = 'Test Teacher'
      end
    end

    context 'when state is teacher' do
      it 'sets the session and redirects to teacher dashboard if teacher exists' do
        # Set up the OmniAuth mock for teacher
        request.env['omniauth.auth'] = mock_auth_hash('test_teacher@tamu.edu')
        get :omniauth, params: { state: 'teacher' }
        expect(response).to redirect_to(teacher_dashboard_path)
      end

      it 'redirects to root if teacher does not exist' do
        # Use an email for which no teacher exists
        request.env['omniauth.auth'] = mock_auth_hash('non_existing_teacher@tamu.edu')
        get :omniauth, params: { state: 'teacher' }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when state is student' do
      Student.where(email: 'test_student@tamu.edu').delete_all
      let!(:student) do
        Student.find_or_create_by!(email: 'test_student@tamu.edu', first_name: 'test', last_name: 'student',
                                   uin: 123_456_789)
      end

      before do
        OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
                                                                             uid: '456',
                                                                             provider: 'google_oauth2',
                                                                             info: { email: student.email,
                                                                                     first_name: student.first_name,
                                                                                     last_name: student.last_name }
                                                                           })
        request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
      end

      it 'redirects to practice_problems_path with a notice' do
        get :omniauth, params: { state: 'student' }
        expect(flash[:notice]).to eq('You are logged in as a student.')
      end
    end

    context 'when state is invalid' do
      it 'redirects to root_path with an alert' do
        get :omniauth, params: { state: 'invalid_state' }
        expect(flash[:alert]).to eq('Invalid user type.')
      end
    end
  end
end
