require 'rails_helper'

RSpec.describe 'practice_problems/engineering_ethics_problem', type: :view do
  let(:category) { 'Engineering Ethics' }

  context 'with an ethics question' do
    let(:question) do
      {
        type: 'engineering_ethics',
        question: 'Test ethics question',
        answer: true
      }
    end

    before do
      assign(:category, category)
      assign(:question, question)
      render
    end

    it 'displays the category title' do
      expect(rendered).to have_content("Category: #{category}")
    end

    it 'displays the question text' do
      expect(rendered).to have_content('Test ethics question')
    end

    it 'displays radio buttons for True and False' do
      expect(rendered).to have_css('input[type="radio"][value="true"]')
      expect(rendered).to have_css('input[type="radio"][value="false"]')
    end

    it 'displays a Check Answer button' do
      expect(rendered).to have_button('Check Answer')
    end
  end
end 