# spec/controllers/practice_problems_controller_spec.rb
require 'rails_helper'

RSpec.describe PracticeProblemsController, type: :controller do
  describe 'GET #index' do
    let(:created_category) { Category.create!(name: 'Test Category') }

    before do
      created_category
      get :index
    end

    it 'includes the newly created category in assigns(:categories)' do
      expect(assigns(:categories)).to include(created_category)
    end

    it 'renders the :index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #generate' do
    let(:category) { Category.create!(name: 'Math') }
    let(:questions) do
      [
        { question: 'Q1', choices: %w[A B], answer: 'A' },
        { question: 'Q2', choices: %w[C D], answer: 'C' }
      ]
    end

    let(:problem_generator) { instance_double(ProblemGenerator) }

    before do
      allow(ProblemGenerator).to receive(:new).with(category).and_return(problem_generator)
    end

    context 'when there is no last question in the session' do
      before do
        allow(problem_generator).to receive(:generate_questions).and_return(questions)
        get :generate, params: { category_id: category.id }
      end

      it 'picks a random question' do
        expect(assigns(:question)).to be_in(questions)
      end

      it 'sets session[:last_question] to the picked question' do
        expect(session[:last_question]).to eq(assigns(:question)[:question])
      end

      it 'renders the :generate template' do
        expect(response).to render_template(:generate)
      end
    end

    context 'when multiple questions exist and a last question is in the session' do
      before do
        session[:last_question] = 'Q1'
        allow(problem_generator).to receive(:generate_questions).and_return(questions)
        get :generate, params: { category_id: category.id }
      end

      it 'filters out Q1 and picks Q2' do
        expect(assigns(:question)[:question]).to eq('Q2')
      end

      it 'updates session[:last_question] to Q2' do
        expect(session[:last_question]).to eq('Q2')
      end

      it 'renders the :generate template' do
        expect(response).to render_template(:generate)
      end
    end

    context 'when only one question exists and a last question is in the session' do
      before do
        session[:last_question] = 'Q1'
        allow(problem_generator).to receive(:generate_questions).and_return([questions.first])
        get :generate, params: { category_id: category.id }
      end

      it 'does NOT filter out Q1 since only one question is available' do
        expect(assigns(:question)[:question]).to eq('Q1')
      end

      it 'keeps session[:last_question] as Q1' do
        expect(session[:last_question]).to eq('Q1')
      end

      it 'renders the :generate template' do
        expect(response).to render_template(:generate)
      end
    end
  end
end
