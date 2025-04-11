# spec/controllers/settings_controller_spec.rb
require 'rails_helper'

RSpec.describe SettingsController, type: :controller do
  describe 'PUT #update' do
    let!(:teacher) { Teacher.create!(name: 'Test Teacher', email: 'test@example.com') }
    let!(:student) do
      Student.create!(
        first_name: 'Test',
        last_name: 'Student',
        email: 'student@example.com',
        uin: 123_456_789,
        semester: 'Fall 2024',
        teacher: teacher
      )
    end

    before do
      session[:user_id] = student.id
    end

    context 'when update is successful' do
      it 'redirects to settings_path with a success notice' do
        put :update, params: { student: { semester: 'Spring 2025' } }
        expect(response).to redirect_to(settings_path)
        expect(flash[:notice]).to eq('Settings updated successfully!')
      end
    end

    context 'when update fails' do
      before do
        # Stub update on any instance so that the update call returns false
        # rubocop:disable RSpec/AnyInstance
        allow_any_instance_of(Student).to receive(:update).and_return(false)
        # rubocop:enable RSpec/AnyInstance
      end

      it 'renders :show with unprocessable_entity and has no flash alert' do
        put :update, params: { student: { semester: 'Invalid' } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:show)
        # Expecting no flash alert because the controller never sets one in this branch
        expect(flash.now[:alert]).to be_nil
      end
    end
  end
end
