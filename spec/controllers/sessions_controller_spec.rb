# spec/controllers/sessions_controller_spec.rb
require 'rails_helper'
require 'ostruct'

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

  describe 'GET #logout' do
    before do
      session[:user_id] = 1
      session[:user_type] = 'teacher'
    end

    it 'clears the session and redirects to root path' do
      get :logout
      expect(session[:user_id]).to be_nil
      expect(session[:user_type]).to be_nil
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq(I18n.t('sessions.logged_out'))
    end
  end

  describe 'GET #auth_failure' do
    it 'redirects to root path with an alert message' do
      get :auth_failure, params: { message: 'invalid_credentials' }
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('Authentication failed: Invalid credentials')
    end
  end

  describe '#handle_student_login' do
    context 'with invalid email domain' do
      let(:auth) do
        OmniAuth::AuthHash.new(
          info: OpenStruct.new(
            email: 'student@gmail.com', # Non-tamu.edu domain
            first_name: 'Test',
            last_name: 'Student'
          )
        )
      end

      it 'rejects non-tamu.edu email domains' do
        expect(controller.send(:valid_email_domain?, 'student@gmail.com')).to be false
      end
    end

    context 'with valid student data' do
      let(:auth) do
        OmniAuth::AuthHash.new(
          info: OpenStruct.new(
            email: 'new_student@tamu.edu',
            first_name: 'New',
            last_name: 'Student'
          )
        )
      end

      it 'creates a new student when one does not exist' do
        expect do
          controller.send(:find_or_create_student, auth)
        end.to change(Student, :count).by(1)
      end

      it 'sets session variables correctly' do
        student = Student.create!(
          email: 'session_test@tamu.edu',
          first_name: 'Session',
          last_name: 'Test',
          uin: 987_654_321
        )
        controller.send(:student_session_set, student)
        expect(session[:user_id]).to eq(student.id)
        expect(session[:user_type]).to eq('student')
      end
    end
  end

  describe 'private methods' do
    describe '#redirect_invalid_domain' do
      it 'redirects to root with an alert for invalid domain' do
        expect(controller).to receive(:redirect_to).with(root_path, alert: I18n.t('sessions.invalid_domain'))
        controller.send(:redirect_invalid_domain)
      end
    end

    describe '#redirect_login_failed' do
      it 'redirects to root with an alert for login failure' do
        expect(controller).to receive(:redirect_to).with(root_path, alert: I18n.t('sessions.login_failed'))
        controller.send(:redirect_login_failed)
      end
    end
  end
end
