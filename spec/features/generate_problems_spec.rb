# spec/features/generate_problems_spec.rb
require 'rails_helper'

RSpec.describe 'practice_problems/generate.html.erb', type: :view do
  let(:category) { Category.create!(name: 'Measurement & Error') }

  context 'with a basic question' do
    let(:question) do
      {
        type: 'multiple_choice',
        question: "What is Newton's second law?",
        choices: ['F = ma', 'E = mc^2', 'P = IV', 'V = IR'],
        answer: 'F = ma'
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
      expect(rendered).to have_content("Category: #{category.name}")
    end

    it 'displays the question text' do
      expect(rendered).to have_content("What is Newton's second law?")
    end

    it 'displays a Change Category link' do
      expect(rendered).to include('Change Category')
    end

    it 'displays a Generate New Problem link' do
      expect(rendered).to include('Generate New Problem')
    end
  end

  context 'with a probability question' do
    let(:question) do
      {
        type: 'probability',
        question: "A probability question\n\nWith formatting instructions",
        answer: 75.5,
        input_fields: nil
      }
    end

    before do
      assign(:category, category)
      assign(:question, question)
      render
    end

    it 'displays the main question' do
      expect(rendered).to include('A probability question')
    end

    it 'displays the formatting instructions separately' do
      expect(rendered).to include('With formatting instructions')
    end

    it 'has a single answer input field' do
      expect(rendered).to have_css('input[name="answer"]')
    end
  end

  context 'with a data statistics question' do
    let(:question) do
      {
        type: 'data_statistics',
        question: 'Calculate the following statistics',
        data_table: [[1.0, 2.0], [3.0, 4.0]],
        answers: { mean: 2.5, median: 2.5 },
        input_fields: [
          { label: 'Mean', key: 'mean' },
          { label: 'Median', key: 'median' }
        ]
      }
    end

    before do
      assign(:category, category)
      assign(:question, question)
      render
    end

    it 'displays the question' do
      expect(rendered).to include('Calculate the following statistics')
    end

    it 'has mean input field' do
      expect(rendered).to have_css('input[name="mean"]')
    end

    it 'has median input field' do
      expect(rendered).to have_css('input[name="median"]')
    end
  end
end
