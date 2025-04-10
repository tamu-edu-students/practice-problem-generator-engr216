require 'rails_helper'

RSpec.describe SettingsController, type: :controller do
  render_views

  describe 'PUT #update' do
    let(:student) { create(:student) }

    before do
      session[:user_id] = student.id
    end

    context 'when update fails' do
      before do
        allow(Student).to receive(:find_by).and_return(student)
        allow(student).to receive(:update).and_return(false)
      end

      it 'sets flash.now alert and renders :show with unprocessable_entity' do
        put :update, params: { student: { semester: 'Fall 2024' } }

        expect(flash.now[:alert]).to eq('Failed to update settings.')
        expect(response).to render_template(:show)
        expect(response.status).to eq(422)
      end
    end
  end
end
