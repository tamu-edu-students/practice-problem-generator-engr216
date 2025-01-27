require 'rails_helper'

RSpec.describe StudentsController, type: :controller do
  let(:valid_attributes) { { first_name: 'John', last_name: 'Doe', uin: '123456789' } }
  let(:invalid_attributes) { { first_name: '', last_name: '', uin: '' } }
  let!(:student) { Student.create(valid_attributes) }

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
      it 'creates a new Student' do
        expect do
          post :create, params: { student: valid_attributes }
        end.to change(Student, :count).by(1)
      end

      it 'redirects to the created student' do
        post :create, params: { student: valid_attributes }
        expect(response).to redirect_to(Student.last)
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
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      let(:new_attributes) { { first_name: 'Jane', last_name: 'Smith' } }

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

      it 'redirects to the student' do
        patch :update, params: { id: student.id, student: new_attributes }
        expect(response).to redirect_to(student)
      end
    end

    context 'with invalid params' do
      it 'renders the edit template' do
        patch :update, params: { id: student.id, student: invalid_attributes }
        expect(response).to render_template(:edit)
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
  end
end
