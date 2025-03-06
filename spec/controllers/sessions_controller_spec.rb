require 'rails_helper'

def mock_auth_hash(email)
  OmniAuth::AuthHash.new({
                           provider: 'google_oauth2',
                           uid: '123456',
                           info: { email: email, first_name: 'Test', last_name: 'User' }
                         })
end

RSpec.describe SessionsController, type: :controller do
  let(:teacher) { Teacher.find_or_create_by!(email: 'test_teacher@tamu.edu') { |t| t.name = 'Test Teacher' } }

  describe 'GET #omniauth' do
    context 'when state is teacher' do
      it 'sets the session and redirects to teacher dashboard if teacher exists' do
        request.env['omniauth.auth'] = mock_auth_hash('test_teacher@tamu.edu')
        get :omniauth, params: { state: 'teacher' }
        expect(session[:user_id]).to eq(teacher.id)
        expect(session[:user_type]).to eq('teacher')
        expect(response).to redirect_to(teacher_dashboard_path)
        expect(flash[:notice]).to eq(I18n.t('teacher.logged_in'))
      end

      it 'redirects to root if teacher does not exist' do
        request.env['omniauth.auth'] = mock_auth_hash('non_existing_teacher@tamu.edu')
        get :omniauth, params: { state: 'teacher' }
        expect(session[:user_id]).to be_nil
        expect(session[:user_type]).to be_nil
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq(I18n.t('sessions.login_failed'))
      end
    end

    context 'when state is student' do
      before do
        Student.where(email: 'test_student@tamu.edu').delete_all
      end

      it 'sets the session and redirects to practice_problems_path with valid tamu.edu email' do
        request.env['omniauth.auth'] = mock_auth_hash('test_student@tamu.edu')
        get :omniauth, params: { state: 'student' }
        created_student = Student.find_by(email: 'test_student@tamu.edu')
        expect(created_student).not_to be_nil, 'Student was not created'
        expect(session[:user_id]).to eq(created_student.id)
        expect(session[:user_type]).to eq('student')
        expect(response).to redirect_to(practice_problems_path)
        expect(flash[:notice]).to eq(I18n.t('student.logged_in'))
      end

      it 'redirects to root_path with invalid email domain' do
        request.env['omniauth.auth'] = mock_auth_hash('test_student@gmail.com')
        get :omniauth, params: { state: 'student' }
        expect(session[:user_id]).to be_nil
        expect(session[:user_type]).to be_nil
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq(I18n.t('sessions.invalid_domain'))
      end

      it 'redirects to root_path if student creation fails' do
        allow(Student).to receive(:find_or_create_by).and_return(nil) # Simulate failure without raising
        request.env['omniauth.auth'] = mock_auth_hash('test_student@tamu.edu')
        get :omniauth, params: { state: 'student' }
        expect(session[:user_id]).to be_nil
        expect(session[:user_type]).to be_nil
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq(I18n.t('sessions.login_failed'))
      end
    end

    context 'when state is invalid' do
      it 'redirects to root_path with an alert' do
        get :omniauth, params: { state: 'invalid_state' }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq(I18n.t('sessions.invalid_user_type'))
      end
    end
  end

  describe 'GET #auth_failure' do
    # Add route permanently in routes.rb instead of dynamically here
    it 'redirects to root_path with an alert' do
      get :auth_failure, params: { message: 'access_denied' }
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('Authentication failed: Access denied')
    end
  end
end
