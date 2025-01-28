# spec/features/login_page_spec.rb
require 'rails_helper'

RSpec.feature "Login Page", type: :feature do
  scenario "visitor sees login options" do
    visit root_path

    expect(page).to have_selector("h1", text: "Login")
    expect(page).to have_button("Teacher Login")
    expect(page).to have_button("Student Login")
  end
end
