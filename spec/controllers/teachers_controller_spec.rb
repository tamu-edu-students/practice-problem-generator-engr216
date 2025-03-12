require 'rails_helper'

RSpec.describe TeachersController, type: :controller do
  describe 'GET #index' do
    it 'assigns all teachers to @teachers' do
      # Create a couple of test teachers
      teacher1 = Teacher.create!(name: 'John Doe', email: 'john@example.com')
      teacher2 = Teacher.create!(name: 'Jane Smith', email: 'jane@example.com')

      # Call the index action
      get :index

      # Verify that @teachers contains all teachers
      expect(assigns(:teachers)).to include(teacher1, teacher2)
    end
  end
end
