# spec/features/login_page_spec.rb
require 'rails_helper'

RSpec.feature 'Login Page', type: :feature do
  scenario 'visitor sees login page' do
    visit root_path

    expect(page).to have_selector('h1', text: 'Login')
  end
end
