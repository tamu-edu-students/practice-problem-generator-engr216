# spec/features/generate_problems_spec.rb
require 'rails_helper'

RSpec.describe 'practice_problems/generate.html.erb', type: :view do
  let(:category) { 'Measurement & Error' }
  let(:question) do
    {
      question: "What is Newton's second law?",
      answer_choices: ['F = ma', 'E = mc^2', 'P = IV', 'V = IR']
    }
  end

  before do
    assign(:category, category)
    assign(:question, question)
    render
  end

  it 'displays the navbar text' do
    expect(rendered).to include('Past Problems')
  end

  it 'displays the category title' do
    expect(rendered).to have_content("Category: #{category}")
  end

  it 'displays the question text' do
    expect(rendered).to have_content("Question: #{question[:question]}")
  end

  it 'displays each answer choice' do
    question[:answer_choices].each do |choice|
      expect(rendered).to include(choice)
    end
  end

  it 'displays a Change Category link' do
    expect(rendered).to include('Change Category')
  end

  it 'displays a Generate New Problem link' do
    expect(rendered).to include('Generate New Problem')
  end
end
