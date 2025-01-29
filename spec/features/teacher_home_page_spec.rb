# spec/features/teacher_home_page_spec.rb
require 'rails_helper'

RSpec.feature 'Teacher Home Page', type: :feature do
  scenario 'teacher sees their home page' do
    visit teachers_path

    expect(page).to have_selector('h1', text: 'All Teachers')
  end
end
