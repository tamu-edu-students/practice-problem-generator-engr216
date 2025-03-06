Before do
  Question.where(category: %w[Mechanics Thermodynamics Electromagnetism]).destroy_all

  Question.find_or_create_by!(category: 'Mechanics') do |q|
    q.question = 'Sample question for Mechanics'
    # Removed q.answers to avoid association type mismatch.
  end
  Question.find_or_create_by!(category: 'Thermodynamics') do |q|
    q.question = 'Sample question for Thermodynamics'
  end
  Question.find_or_create_by!(category: 'Electromagnetism') do |q|
    q.question = 'Sample question for Electromagnetism'
  end
end

# Given('I am on the practice problem generator page and I am logged in as a student') do
#   visit '/practice_problems'
# end

# Then('I see a list of physics categories, including {string} {string} {string}  etc.') do |string, string2, string3|
#   expect(page).to have_select('category_select', with_options: [string, string2, string3])
# end

# When('I select the {string} category') do |category_name|
#   select category_name, from: 'category_select'
# end

# When('I click on the "Generate Problems" button') do
#   click_button 'Generate Problems'
# end

# Then('I am presented with a set of questions from the {string} category') do |category_name|
#   expect(page).to have_content("Questions for #{category_name}")
# end

# Then('I am presented with a set of multiple-choice questions from the {string} category.') do |category_name|
#   expect(page).to have_content("Questions for #{category_name}")
# end
