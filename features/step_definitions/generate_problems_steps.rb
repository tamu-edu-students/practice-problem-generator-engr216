# features/step_definitions/generate_problems_steps.rb

Given("I am on the select problem category page") do
  # Ensure there's at least one category in the database.
  if Category.count == 0
    Category.create!(name: "Measurement & Error")
  end
  visit practice_problems_path
end

When("I select a category") do
  # Assuming your select category page displays categories as links with the category names.
  category = Category.first
  click_link(category.name)
end

Then("I should be on the generate problem page") do
  # Verify that the page displays content that indicates a generated problem.
  expect(page).to have_content("Question:")
end

Given("I am on the generate problems page") do
  # Ensure a category exists, then visit the generate page for that category.
  category = Category.first || Category.create!(name: "Measurement & Error")
  visit generate_practice_problems_path(category_id: category.id)
end

When("I click generate problem") do
  click_link "Generate New Problem"
end

Then("I should see a problem") do
  expect(page).to have_content("Question:")
end

Given("I have already generated a problem") do
  @first_question = find("p.font-semibold.text-3xl", match: :first).text
end

Then("I should see a different problem") do
  new_question = find("p.font-semibold.text-3xl", match: :first).text
  expect(new_question).not_to eq(@first_question)
end

When("I click change category") do
  click_link "Change Category"
end

Then("I should be on the select problem category page") do
  # Verify the page shows the heading unique to the category selection page.
  expect(page).to have_content("Select Category")
end
