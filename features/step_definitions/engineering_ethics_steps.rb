Given(/^I am on the "Engineering Ethics" page$/) do
  visit generate_practice_problems_path(category_id: 'Engineering Ethics')
end

When(/^I click the "new problem" button$/) do
  click_link 'Generate New Problem'
end

Then(/^a new "Engineering Ethics" problem should be dynamically generated$/) do
  expect(page).to have_css('h1', text: 'Engineering Ethics Question:')
  expect(page).to have_content('Is this statement true or false?')
end

When(/^I submit an answer$/) do
  choose 'True'
  click_button 'Check Answer'
end

Then(/^I should receive feedback on my answer$/) do
  expect(page).to(satisfy do |page|
    page.has_text?(/correct/i) || page.has_text?(/incorrect/i)
  end)
end
