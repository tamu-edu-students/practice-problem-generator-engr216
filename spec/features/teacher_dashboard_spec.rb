require 'rails_helper'

RSpec.feature "Teacher Dashboard", type: :feature do
  scenario "User visits the dashboard page" do
    visit teacher_dashboard_path

    expect(page).to have_content("Teacher Dashboard")

    expect
    
  end
end
