require 'rails_helper'

def mock_auth_hash(email)
  OmniAuth::AuthHash.new({
    provider: 'google_oauth2',
    uid: '123456',
    info: { email: email, first_name: 'Test', last_name: 'Teacher' }
  })
end

RSpec.describe TeacherDashboardController, type: :controller do
  let(:teacher) { Teacher.find_or_create_by!(email: "test_teacher@tamu.edu") { |t| t.name = "Test Teacher" } }
  let(:student) do
    Student.find_or_create_by!(email: "test_student@tamu.edu") do |s|
      s.first_name = "Test"
      s.last_name = "Student"
      s.uin = "123456789"
      s.teacher_id = teacher.id
    end
  end

  before(:each) do
    # Mock OmniAuth response
    request.env['omniauth.auth'] = mock_auth_hash(teacher.email)
    # Set session to satisfy require_teacher by default
    session[:user_id] = teacher.id
    session[:user_type] = "teacher"
  end

  describe "GET #index" do
    context "when logged in as a teacher" do
      it "assigns all students to @students" do
        get :index
        expect(assigns(:students)).to eq(Student.all)
      end

      it "renders the index template" do
        get :index
        expect(response).to render_template(:index)
      end
    end

    context "when not logged in as a teacher" do
      before do
        session[:user_type] = "student" # Simulate non-teacher session
      end

      it "redirects to login_path" do
        get :index
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "GET #manage_students" do
    context "when logged in as a teacher" do
      it "assigns all students to @students" do
        get :manage_students
        expect(assigns(:students)).to eq(Student.all)
      end

      it "renders the manage_students template" do
        get :manage_students
        expect(response).to render_template(:manage_students)
      end
    end

    context "when not logged in as a teacher" do
      before do
        session[:user_type] = nil # Simulate no user type
      end

      it "redirects to login_path" do
        get :manage_students
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "#require_teacher" do
    context "when session[:user_type] is 'teacher'" do
      it "allows the action to proceed without redirect" do
        get :index
        expect(response).to have_http_status(:ok)
        expect(response).not_to redirect_to(login_path)
      end
    end

    context "when session[:user_type] is not 'teacher'" do
      before do
        session[:user_type] = "student"
      end

      it "redirects to login_path" do
        get :index
        expect(response).to redirect_to(login_path)
      end
    end

    context "when session[:user_type] is nil" do
      before do
        session[:user_type] = nil
      end

      it "redirects to login_path" do
        get :index
        expect(response).to redirect_to(login_path)
      end
    end
  end
end