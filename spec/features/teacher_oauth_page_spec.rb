# spec/features/teacher_oath_page_spec.rb
require 'rails_helper'

RSpec.feature "Teacher Oauth Page", type: :feature do
  scenario "visitor sees the teacher oath" do
    visit teacher_oauth_path

    expect(page).to have_selector("h1", text: "Teacher Oauth")
  end
end
