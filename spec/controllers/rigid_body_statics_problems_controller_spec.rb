require 'rails_helper'

RSpec.describe RigidBodyStaticsProblemsController, type: :controller do
  let(:tolerance) { 0.05 }

  describe '#evaluate_answer' do
    subject(:result) { controller.send(:evaluate_answer, correct_answer, tolerance) }

    let!(:student) do
      Student.create!(email: 'test@example.com', first_name: 'test', last_name: 'student', uin: '123456789')
    end

    before do
      session[:user_id] = student.id
      controller.instance_variable_set(:@question, { type: 'rigid_body_statics' })
    end

    context 'when correct_answer is not an Array' do
      let(:correct_answer) { '18.4' }

      before do
        allow(controller).to receive(:check_single_answer)
          .with('18.4', tolerance).and_return('single answer branch')
      end

      it 'calls check_single_answer and returns its value' do
        expect(result).to eq('single answer branch')
      end
    end
  end

  describe '#check_multi_part_answer' do
    subject(:multi_result) { controller.send(:check_multi_part_answer, correct_answers, tolerance) }

    let!(:student) do
      Student.create!(email: 'test@example.com', first_name: 'test', last_name: 'student', uin: '123456789')
    end
    let(:correct_answers) { %w[A B] }

    before do
      question = {
        type: 'rigid_body_statics',
        question: 'Dummy multi-part question',
        answer: correct_answers,
        input_fields: [
          { label: 'Answer 1', key: 'rbs_answer_1', type: 'text' },
          { label: 'Answer 2', key: 'rbs_answer_2', type: 'text' }
        ]
      }
      controller.instance_variable_set(:@question, question)
      session[:current_question] = question.to_json
      session[:user_id] = student.id
    end

    context 'when all submitted answers are numeric and within tolerance' do
      let(:correct_answers) { ['18.4', '20.0'] }

      before do
        allow(controller).to receive(:params).and_return({
                                                           'rbs_answer_1' => '18.43',
                                                           'rbs_answer_2' => '20.00'
                                                         })
      end

      it 'returns a correct feedback message' do
        expect(multi_result).to eq('Correct, the answer 18.4, 20.0 is right!')
      end
    end

    context 'when numeric conversion fails so string comparison is used' do
      before do
        allow(controller).to receive(:params).and_return({
                                                           'rbs_answer_1' => 'A',
                                                           'rbs_answer_2' => 'B'
                                                         })
      end

      it 'returns a correct feedback message using string comparison' do
        expect(multi_result).to eq('Correct, the answer A, B is right!')
      end
    end

    context 'when one submitted answer does not match' do
      before do
        allow(controller).to receive(:params).and_return({
                                                           'rbs_answer_1' => 'X',
                                                           'rbs_answer_2' => 'B'
                                                         })
      end

      it 'returns an incorrect feedback message' do
        expect(multi_result).to eq('Incorrect, the correct answer is A, B.')
      end
    end

    context 'when an exception is raised during numeric? conversion' do
      before do
        allow(controller).to receive(:numeric?).and_raise(ArgumentError)
        allow(controller).to receive(:params).and_return({
                                                           'rbs_answer_1' => 'A',
                                                           'rbs_answer_2' => 'B'
                                                         })
      end

      it 'rescues the error and returns false for each element, resulting in an incorrect message' do
        expect(multi_result).to eq('Incorrect, the correct answer is A, B.')
      end
    end
  end

  describe '#check_single_answer' do
    subject(:single_result) { controller.send(:check_single_answer, correct_answer, tolerance) }

    let!(:student) do
      Student.create!(email: 'test@example.com', first_name: 'test', last_name: 'student', uin: '123456789')
    end
    let(:correct_answers) { %w[A B] }

    before do
      question = {
        type: 'rigid_body_statics',
        question: 'Dummy multi-part question',
        answer: correct_answers,
        input_fields: [
          { label: 'Answer 1', key: 'rbs_answer_1', type: 'text' },
          { label: 'Answer 2', key: 'rbs_answer_2', type: 'text' }
        ]
      }
      controller.instance_variable_set(:@question, question)
      session[:current_question] = question.to_json
      session[:user_id] = student.id
    end

    context 'when the answer is numeric and within tolerance' do
      let(:correct_answer) { '18.4' }

      before do
        allow(controller).to receive(:params).and_return({ rbs_answer: '18.42' })
      end

      it 'returns a correct feedback message' do
        expect(single_result).to eq('Correct, the answer 18.4 is right!')
      end
    end

    context 'when the answer is numeric but out of tolerance' do
      let(:correct_answer) { '18.4' }

      before do
        allow(controller).to receive(:params).and_return({ rbs_answer: '17.0' })
      end

      it 'returns an incorrect feedback message' do
        expect(single_result).to eq('Incorrect, the correct answer is 18.4.')
      end
    end

    context 'when the answer is non-numeric and submitted answer matches exactly' do
      let(:correct_answer) { 'AnswerX' }

      before do
        allow(controller).to receive(:params).and_return({ rbs_answer: 'AnswerX' })
      end

      it 'returns a correct feedback message' do
        expect(single_result).to eq('Correct, the answer AnswerX is right!')
      end
    end

    context 'when the answer is non-numeric and submitted answer does not match' do
      let(:correct_answer) { 'AnswerX' }

      before do
        allow(controller).to receive(:params).and_return({ rbs_answer: 'WrongAnswer' })
      end

      it 'returns an incorrect feedback message' do
        expect(single_result).to eq('Incorrect, the correct answer is AnswerX.')
      end
    end
  end

  describe '#numeric?' do
    subject(:numeric_result) { controller.send(:numeric?, input) }

    context 'with a valid numeric string' do
      let(:input) { '123.45' }

      it { is_expected.to be(true) }
    end

    context 'with a non-numeric string' do
      let(:input) { 'abc' }

      it { is_expected.to be(false) }
    end
  end

  describe '#generate' do
    let(:student) do
      Student.create!(email: 'test@example.com', first_name: 'test', last_name: 'student', uin: '123456789')
    end
    let(:mock_question) do
      {
        type: 'rigid_body_statics',
        question: 'Test RBS question',
        answer: '42',
        input_fields: [{ label: 'Your answer', key: 'rbs_answer', type: 'text' }]
      }
    end

    before do
      session[:user_id] = student.id
      generator_double = instance_double(RigidBodyStaticsProblemGenerator, generate_questions: [mock_question])
      allow(RigidBodyStaticsProblemGenerator).to receive(:new).and_return(generator_double)
    end

    it 'generates a new question and stores it in session' do
      get :generate
      expect(session[:current_question]).to be_present
      expect(session[:problem_start_time]).to be_present
      expect(JSON.parse(session[:current_question], symbolize_names: true)).to eq(mock_question)
      expect(response).to render_template('practice_problems/rigid_body_statics_problem')
    end
  end

  describe '#check_answer' do
    let(:student) do
      Student.create!(email: 'test@example.com', first_name: 'test', last_name: 'student', uin: '123456789')
    end
    let(:mock_question) do
      {
        type: 'rigid_body_statics',
        question: 'Test RBS question',
        answer: '42',
        input_fields: [{ label: 'Your answer', key: 'rbs_answer', type: 'text' }]
      }
    end

    before do
      session[:user_id] = student.id
      session[:current_question] = mock_question.to_json
      session[:problem_start_time] = Time.current.to_s
    end

    it 'evaluates the answer and renders the template' do
      allow(controller).to receive(:params).and_return({ rbs_answer: '42' })

      get :check_answer

      expect(assigns(:category)).to eq('Rigid Body Statics')
      expect(assigns(:question)).to eq(mock_question)
      expect(assigns(:feedback_message)).to include('Correct')
      expect(response).to render_template('practice_problems/rigid_body_statics_problem')
    end
  end

  describe '#save_answer_to_database' do
    let(:student) do
      Student.create!(email: 'test@example.com', first_name: 'test', last_name: 'student', uin: '123456789')
    end
    let(:mock_question) do
      {
        type: 'rigid_body_statics',
        question: 'Test RBS question',
        answer: '42',
        input_fields: [{ label: 'Your answer', key: 'rbs_answer', type: 'text' }]
      }
    end

    before do
      session[:user_id] = student.id
      controller.instance_variable_set(:@category, 'Rigid Body Statics')
      controller.instance_variable_set(:@question, mock_question)
      session[:problem_start_time] = 30.seconds.ago.to_s
    end

    it 'increments Answer count' do
      expect do
        controller.send(:save_answer_to_database, true, '42')
      end.to change(Answer, :count).by(1)
    end

    it 'creates an Answer record in the database with correct attributes' do
      controller.send(:save_answer_to_database, true, '42')
      answer = Answer.last
      expect(answer.category).to eq('Rigid Body Statics')
      expect(answer.question_description).to eq('Test RBS question')
      expect(answer.answer).to eq('42')
      expect(answer.correctness).to be(true)
      expect(answer.student_email).to eq(student.email)
    end

    it 'calculates time spent on the problem' do
      controller.send(:save_answer_to_database, true, '42')
      answer = Answer.last
      expect(answer.time_spent).to be_present
      expect(answer.time_spent.to_i).to be >= 29
    end
  end

  describe '#extract_answer_choices' do
    context 'when question has answer_choices' do
      before do
        controller.instance_variable_set(:@question, {
                                           answer_choices: %w[A B C]
                                         })
      end

      it 'returns the answer choices as JSON' do
        expect(controller.send(:extract_answer_choices)).to eq('["A","B","C"]')
      end
    end

    context 'when question has no answer_choices' do
      before do
        controller.instance_variable_set(:@question, {})
      end

      it 'returns empty array as JSON' do
        expect(controller.send(:extract_answer_choices)).to eq('[]')
      end
    end

    context 'when an error occurs during serialization' do
      before do
        question_mock = instance_double(Hash)
        allow(question_mock).to receive(:[]).and_raise(StandardError)
        controller.instance_variable_set(:@question, question_mock)
      end

      it 'returns nil' do
        expect(controller.send(:extract_answer_choices)).to be_nil
      end
    end
  end
end
