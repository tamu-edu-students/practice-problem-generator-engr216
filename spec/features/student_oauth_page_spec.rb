# spec/features/student_oath_page_spec.rb
require 'rails_helper'

RSpec.feature 'Student Oauth Page', type: :feature do
  scenario 'visitor sees the student oath' do
    visit student_oauth_path

    expect(page).to have_selector('h1', text: 'Student Oauth')
  end
end
