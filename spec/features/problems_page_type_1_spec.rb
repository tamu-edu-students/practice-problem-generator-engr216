# spec/features/
require 'rails_helper'

RSpec.feature "Problem-type 1 Page", type: :feature do
  scenario "User sees problem-type 1 problems" do
    visit problem_type_1_path

    expect(page).to have_selector("h1", text: "Problem-type 1")
  end
end
