require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe 'GET #login' do
    it 'returns a successful response' do
      get :login
      expect(response).to be_successful
    end

    it 'renders the login template' do
      get :login
      expect(response).to render_template(:login)
    end
  end

  describe 'GET #teacher_oauth' do
    it 'redirects to Google OAuth with teacher state' do
      get :teacher_oauth
      expect(response).to redirect_to('/auth/google_oauth2?state=teacher')
    end
  end

  describe 'GET #student_oauth' do
    it 'redirects to Google OAuth with student state' do
      get :student_oauth
      expect(response).to redirect_to('/auth/google_oauth2?state=student')
    end
  end

  describe 'GET #student_home' do
    it 'redirects to practice problems path' do
      get :student_home
      expect(response).to redirect_to(practice_problems_path)
    end
  end

  describe 'GET #teacher_home' do
    it 'redirects to teacher dashboard path' do
      get :teacher_home
      expect(response).to redirect_to(teacher_dashboard_path)
    end
  end

  describe 'GET #problem_type1' do
    it 'redirects to practice problems path' do
      get :problem_type1
      expect(response).to redirect_to(practice_problems_path)
    end
  end
end
