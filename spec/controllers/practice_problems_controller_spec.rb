require 'rails_helper'

RSpec.describe PracticeProblemsController, type: :controller do
  describe 'GET #index' do
    before do
      Category.delete_all
    end

    let!(:category) { Category.create!(name: 'Mechanics') }

    it 'assigns all categories to @categories' do
      get :index
      expect(assigns(:categories)).to eq([category])
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end
end
