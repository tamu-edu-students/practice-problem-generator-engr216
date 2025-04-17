Then('I should see a per-category difficulty breakdown') do
  expect(page).to have_content('Per-Category Breakdown')
  expect(page).to have_css('.grid-cols-1.md\\:grid-cols-2')
end

Then('each category should show a total number of problems') do
  expected_categories = [
    'Angular Momentum', 'Confidence Intervals', 'Engineering Ethics',
    'Experimental Statistics', 'Finite Differences', 'Harmonic Motion',
    'Measurement & Error', 'Momentum & Collisions', 'Particle Statics',
    'Propagation of Error', 'Rigid Body Statics', 'Universal Accounting Equation'
  ]

  expected_categories.each do |cat|
    expect(page).to have_text(cat)
    expect(page).to have_text('Out of')
  end
end

Then('each section should reflect overall student performance') do
  expect(page).to have_css('canvas[id^="attempted-"]')
  expect(page).to have_css('canvas[id^="correct-"]')
end

Then('I should see one bar chart for attempted per category') do
  expect(page).to have_css('canvas[id^="attempted-"]', minimum: 1)
end

Then('I should see one bar chart for correct per category') do
  expect(page).to have_css('canvas[id^="correct-"]', minimum: 1)
end

Then('each bar should represent a specific category') do
  categories = [
    'Angular Momentum', 'Confidence Intervals', 'Engineering Ethics',
    'Experimental Statistics', 'Finite Differences', 'Harmonic Motion',
    'Measurement & Error', 'Momentum & Collisions', 'Particle Statics',
    'Propagation of Error', 'Rigid Body Statics', 'Universal Accounting Equation'
  ]

  categories.each do |cat|
    attempted_id = "attempted-#{cat.parameterize}"
    correct_id   = "correct-#{cat.parameterize}"

    expect(page).to have_css("canvas##{attempted_id}")
    expect(page).to have_css("canvas##{correct_id}")
  end
end

Then('I should not see a performance summary table') do
  expect(page).not_to have_css('table.performance-summary')
  expect(page).not_to have_text('Performance Summary')
end

Then('I should see category-level difficulty charts instead') do
  expect(page).to have_content('Per-Category Breakdown')
  expect(page).to have_css('canvas[id^="attempted-"]')
  expect(page).to have_css('canvas[id^="correct-"]')
end
