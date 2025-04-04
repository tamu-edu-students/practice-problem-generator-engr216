require 'rails_helper'

RSpec.describe StudentsController, type: :controller do
  before do
    Student.delete_all
    Teacher.delete_all
  end

  let(:valid_attributes) do
    { first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com', uin: '123456789', authenticate: false }
  end
  let(:invalid_attributes) { { first_name: '', last_name: '', email: '', uin: '' } }
  let!(:student) { Student.create!(valid_attributes) }
  let(:teacher) { Teacher.create!(email: 'teacher@example.com', name: 'Test Teacher') }

  describe 'GET #index' do
    it 'assigns all students as @students' do
      get :index
      expect(assigns(:students)).to eq([student])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested student as @student' do
      get :show, params: { id: student.id }
      expect(assigns(:student)).to eq(student)
    end
  end

  describe 'GET #new' do
    it 'assigns a new student as @student' do
      get :new
      expect(assigns(:student)).to be_a_new(Student)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested student as @student' do
      get :edit, params: { id: student.id }
      expect(assigns(:student)).to eq(student)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:new_valid_attributes) { valid_attributes.merge(email: 'unique@example.com') }

      it 'creates a new Student' do
        expect do
          post :create, params: { student: new_valid_attributes }
        end.to change(Student, :count).by(1)
      end

      it 'redirects to the created student' do
        post :create, params: { student: new_valid_attributes }
        expect(response).to redirect_to(Student.last)
      end

      it 'sets a success notice' do
        post :create, params: { student: new_valid_attributes }
        expect(flash[:notice]).to eq(I18n.t('student.created'))
      end

      it 'responds with JSON status created (no body expected yet)' do
        post :create, params: { student: new_valid_attributes }, format: :json
        expect(response).to have_http_status(:created)
        expect(response.body).to be_empty # Current behavior until view or render is fixed
      end
    end

    context 'with invalid params' do
      it 'does not create a new Student' do
        expect do
          post :create, params: { student: invalid_attributes }
        end.not_to change(Student, :count)
      end

      it 'renders the new template' do
        post :create, params: { student: invalid_attributes }
        expect(response).to render_template(:new)
      end

      it 'returns unprocessable_entity status with JSON' do
        post :create, params: { student: invalid_attributes }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body).to have_key('email')
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      let(:new_attributes) { { first_name: 'Jane', last_name: 'Smith', email: 'jane.smith@example.com' } }

      it 'updates the requested student first name' do
        patch :update, params: { id: student.id, student: new_attributes }
        student.reload
        expect(student.first_name).to eq('Jane')
      end

      it 'updates the requested student last name' do
        patch :update, params: { id: student.id, student: new_attributes }
        student.reload
        expect(student.last_name).to eq('Smith')
      end

      it 'updates the requested student email' do
        patch :update, params: { id: student.id, student: new_attributes }
        student.reload
        expect(student.email).to eq('jane.smith@example.com')
      end

      it 'redirects to manage_students_path' do
        patch :update, params: { id: student.id, student: new_attributes }
        expect(response).to redirect_to(manage_students_path)
      end

      it 'sets a success notice' do
        patch :update, params: { id: student.id, student: new_attributes }
        expect(flash[:notice]).to eq(I18n.t('student.updated'))
      end

      it 'responds with JSON status ok (no body expected yet)' do
        patch :update, params: { id: student.id, student: new_attributes }, format: :json
        expect(response).to have_http_status(:ok)
        expect(response.body).to be_empty # Current behavior until view or render is fixed
      end
    end

    context 'with invalid params' do
      it 'does not update the student' do
        original_attributes = student.attributes
        patch :update, params: { id: student.id, student: invalid_attributes }
        student.reload
        expect(student.attributes).to include(original_attributes.slice('first_name', 'last_name', 'email'))
      end

      it 'renders the edit template' do
        patch :update, params: { id: student.id, student: invalid_attributes }
        expect(response).to render_template(:edit)
      end

      it 'returns unprocessable_entity status with JSON' do
        patch :update, params: { id: student.id, student: invalid_attributes }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body).to have_key('email')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested student' do
      expect do
        delete :destroy, params: { id: student.id }
      end.to change(Student, :count).by(-1)
    end

    it 'redirects to the students list' do
      delete :destroy, params: { id: student.id }
      expect(response).to redirect_to(students_path)
    end

    it 'sets a success notice' do
      delete :destroy, params: { id: student.id }
      expect(flash[:notice]).to eq(I18n.t('student.destroyed'))
    end

    it 'responds with no_content status in JSON' do
      delete :destroy, params: { id: student.id }, format: :json
      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'POST #update_uin' do
    context 'when student is logged in with valid params' do
      before do
        session[:user_id] = student.id
      end

      it 'updates the student’s uin and teacher' do
        post :update_uin, params: { uin: '987654321', teacher_id: teacher.id }
        student.reload
        expect(student.uin).to eq(987_654_321)
        expect(student.teacher).to eq(teacher)
      end

      it 'redirects to practice_problems_path with success notice' do
        post :update_uin, params: { uin: '987654321', teacher_id: teacher.id }
        expect(response).to redirect_to(practice_problems_path)
        expect(flash[:notice]).to eq(I18n.t('student.update_uin.success'))
      end
    end

    context 'when student is not logged in' do
      it 'redirects to practice_problems_path with error' do
        post :update_uin, params: { uin: '987654321', teacher_id: teacher.id }
        expect(response).to redirect_to(practice_problems_path)
        expect(flash[:alert]).to eq(I18n.t('student.update_uin.error'))
      end
    end

    context 'with invalid uin' do
      before { session[:user_id] = student.id }

      it 'does not update uin and sets error message' do
        original_uin = student.uin
        post :update_uin, params: { uin: 'invalid', teacher_id: teacher.id }
        student.reload
        expect(student.uin).to eq(original_uin)
        expect(flash[:alert]).to eq(I18n.t('student.update_uin.error'))
      end
    end

    context 'with invalid teacher_id' do
      before { session[:user_id] = student.id }

      it 'does not update teacher and sets not_found message' do
        original_teacher = student.teacher
        post :update_uin, params: { uin: '987654321', teacher_id: 999 }
        student.reload
        expect(student.teacher).to eq(original_teacher)
        expect(flash[:alert]).to eq(I18n.t('student.update_uin.not_found'))
      end
    end
  end
end
