require 'rails_helper'

# Helper method to mock OmniAuth
def mock_auth_hash(email)
  OmniAuth::AuthHash.new({
                           provider: 'google_oauth2',
                           uid: '123456',
                           info: { email: email, first_name: 'Test', last_name: 'Teacher' }
                         })
end

RSpec.describe TeacherDashboard::StudentStatisticsController, type: :controller do
  let(:teacher) { Teacher.find_or_create_by!(email: 'test_teacher@tamu.edu') { |t| t.name = 'Test Teacher' } }
  let(:student) do
    Student.find_or_create_by!(email: 'test_student@tamu.edu') do |s|
      s.first_name = 'Test'
      s.last_name = 'Student'
      s.uin = '123456789'
      s.teacher_id = teacher.id
    end
  end
  let(:category) { Category.find_or_create_by!(name: 'Math') }

  before do
    # Mock OmniAuth response
    request.env['omniauth.auth'] = mock_auth_hash(teacher.email)
    # Set session to match require_teacher_login and current_teacher
    session[:user_id] = teacher.id
    session[:user_type] = 'teacher'
    # Remove the stub to let current_teacher run naturally
    # allow(controller).to receive(:current_teacher).and_return(teacher) # Commented out
  end

  describe 'GET #index' do
    it 'assigns the teacher’s students to @students' do
      get :index
      expect(assigns(:students)).to eq(Student.where(teacher_id: teacher.id))
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    context 'when the student exists' do
      before do
        StudentCategoryStatistic.find_or_create_by!(
          student_id: student.id,
          category_id: category.id
        ) do |stat|
          stat.attempts = 2
          stat.correct_attempts = 1
        end
      end

      it 'assigns the requested student to @student' do
        get :show, params: { id: student.id }
        expect(assigns(:student)).to eq(student)
      end

      it 'assigns the student’s statistics to @stats' do
        get :show, params: { id: student.id }
        expect(assigns(:stats)).to match_array(StudentCategoryStatistic.where(student_id: student.id))
      end

      it 'sets the summary with correct totals' do
        get :show, params: { id: student.id }
        expect(assigns(:summary)).to eq('Total problems: 2, Correct: 1, Incorrect: 1')
      end

      it 'renders the show template' do
        get :show, params: { id: student.id }
        expect(response).to render_template(:show)
      end
    end

    context 'when the student does not exist' do
      it 'raises an ActiveRecord::RecordNotFound error' do
        expect do
          get :show, params: { id: 9999 }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#current_teacher' do
    it 'returns the logged-in teacher' do
      # Call the private method directly
      expect(controller.send(:current_teacher)).to eq(teacher)
    end

    context 'when not logged in as teacher' do
      before do
        session[:user_type] = 'student' # Simulate non-teacher session
      end

      it 'returns nil' do
        expect(controller.send(:current_teacher)).to be_nil
      end
    end
  end
end
