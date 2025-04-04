require 'rails_helper'

RSpec.describe TeachersController, type: :controller do
  describe 'GET #index' do
    it 'assigns all teachers to @teachers' do
      teacher1 = Teacher.create!(name: 'John Doe', email: 'john@example.com')
      teacher2 = Teacher.create!(name: 'Jane Smith', email: 'jane@example.com')

      get :index

      expect(assigns(:teachers)).to match_array([teacher1, teacher2])
    end
  end
end