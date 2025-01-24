Given('I am on the Problem\'s page') do
    visit problem_type_1_path
  end
  
  When('I click on the "Home" button') do 
    click_button('Home')
  end
  
  Then('I should be redirected to the Student Home view') do
    expect(current_path).to eq(student_home_path)
  end