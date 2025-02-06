# spec/features/student_home_page_spec.rb
require 'rails_helper'

RSpec.feature 'Student Home Page', type: :feature do
  scenario 'student sees their home page' do
    visit practice_problems_path

    expect(page).to have_selector('h1', text: 'Howdy, Student')
  end
end
