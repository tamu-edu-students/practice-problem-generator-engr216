require 'rails_helper'

RSpec.describe 'Settings', type: :request do
  describe 'GET /show' do
    let!(:semester) { Semester.create!(name: "Test Fall 2024 Request #{Time.now.to_i}", active: true) }
    let!(:student) do
      Student.create!(
        first_name: 'Test',
        last_name: 'Student',
        email: 'test@student.com',
        uin: 123_456_789,
        semester_id: semester.id
      )
    end

    before do
      # rubocop:disable RSpec/AnyInstance
      allow_any_instance_of(ApplicationController).to receive(:session).and_return({ user_id: student.id })
      # rubocop:enable RSpec/AnyInstance
    end

    it 'returns http success' do
      get settings_path
      expect(response).to have_http_status(:success)
    end
  end
end
