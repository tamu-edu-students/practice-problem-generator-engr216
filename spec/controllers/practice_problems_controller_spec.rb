require 'rails_helper'

RSpec.describe PracticeProblemsController, type: :controller do
  describe 'GET #index' do
    it 'assigns all categories to @categories' do
      category = Category.create!(name: 'Mechanics')
      get :index
      expect(assigns(:categories)).to eq([category])
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end
end
