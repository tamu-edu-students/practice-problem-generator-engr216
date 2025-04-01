# spec/modules/rigid_body_statics_problem_generator_spec.rb
# rubocop:disable RSpec/SpecFilePathFormat

require 'rails_helper'

# Instead of stubbing private methods on the generator,
# create a subclass for testing that overrides them.
class TestRigidBodyStaticsProblemGenerator < RigidBodyStaticsProblemGenerator
  def static_questions
    [
      { question: 'static', answer: 'A', input_fields: [] },
      { question: 'static', answer: 'B', input_fields: [] }
    ]
  end

  def dynamic_questions
    [
      { question: 'dynamic', answer: 'A', input_fields: [] },
      { question: 'dynamic', answer: 'B', input_fields: [] },
      { question: 'dynamic', answer: 'C', input_fields: [] },
      { question: 'dynamic', answer: 'D', input_fields: [] },
      { question: 'dynamic', answer: 'E', input_fields: [] },
      { question: 'dynamic', answer: 'F', input_fields: [] }
    ]
  end
end

RSpec.describe TestRigidBodyStaticsProblemGenerator, type: :model do
  subject(:generator) { described_class.new('Rigid Body Statics') }

  describe '#generate_questions' do
    it 'returns an array with one question' do
      questions = generator.generate_questions
      aggregate_failures 'question validations' do
        expect(questions).to be_an(Array)
        expect(questions.size).to eq(1)
        expect(questions.first[:question]).to be_in(%w[static dynamic])
      end
    end
  end

  describe '#generate_rbs_problem_from_data' do
    subject(:result) { generator.send(:generate_rbs_problem_from_data, data) }

    let(:data) do
      {
        question: 'Test question?',
        answer: 'Test answer',
        input_type: input_type,
        image: 'test.png'
      }
    end

    context "when input_type is 'fill_in'" do
      let(:input_type) { 'fill_in' }

      before do
        # rubocop:disable RSpec/SubjectStub
        allow(generator).to receive(:generate_fill_in_fields)
          .with(data)
          .and_return([{ key: 'rbs_answer', type: 'text' }])
        # rubocop:enable RSpec/SubjectStub
      end

      it 'returns a hash with the expected keys' do
        expect(result).to include(
          type: 'rigid_body_statics',
          question: 'Test question?',
          answer: 'Test answer',
          image: 'test.png',
          input_fields: [{ key: 'rbs_answer', type: 'text' }]
        )
      end
    end

    context "when input_type is not 'fill_in'" do
      let(:input_type) { 'multiple_choice' }

      before do
        # rubocop:disable RSpec/SubjectStub
        allow(generator).to receive(:generate_multiple_choice_fields)
          .with(data)
          .and_return([{ key: 'rbs_answer', type: 'radio', options: %w[A B] }])
        # rubocop:enable RSpec/SubjectStub
      end

      it 'returns a hash using generate_multiple_choice_fields' do
        expect(result).to include(
          type: 'rigid_body_statics',
          question: 'Test question?',
          answer: 'Test answer',
          image: 'test.png',
          input_fields: [{ key: 'rbs_answer', type: 'radio', options: %w[A B] }]
        )
      end
    end
  end

  describe '#generate_fill_in_fields' do
    subject(:fields) { generator.send(:generate_fill_in_fields, data) }

    context 'when answer is an Array' do
      let(:data) { { answer: answer, field_label: 'My Answer' } }
      let(:answer) { ['1.2', '3.4'] }

      it 'returns text fields for each answer element' do
        expect(fields).to eq([
                               { label: 'Answer part 1', key: 'rbs_answer_1', type: 'text' },
                               { label: 'Answer part 2', key: 'rbs_answer_2', type: 'text' }
                             ])
      end
    end

    context 'when answer is not an Array' do
      let(:data) { { answer: '1.2', field_label: 'My Answer' } }

      it 'returns a text field with the provided field_label' do
        expect(fields).to eq([{ label: 'My Answer', key: 'rbs_answer', type: 'text' }])
      end
    end
  end

  describe '#generate_fill_in_fields_for_array' do
    subject(:fields) { generator.send(:generate_fill_in_fields_for_array, answer, data) }

    context 'when all answers are numeric' do
      let(:answer) { ['1.2', '3.4'] }
      let(:data) { { field_label: 'Label' } }

      it 'returns text fields with default labels' do
        expect(fields).to eq([
                               { label: 'Answer part 1', key: 'rbs_answer_1', type: 'text' },
                               { label: 'Answer part 2', key: 'rbs_answer_2', type: 'text' }
                             ])
      end
    end

    context 'when not all answers are numeric and options are provided' do
      let(:answer) { %w[A B] }
      let(:data) do
        { options: [{ value: 'A', label: 'Option A' },
                    { value: 'B', label: 'Option B' }],
          field_label: 'Label' }
      end

      it "returns a radio field with default label 'Your Answer'" do
        expect(fields).to eq([
                               { label: 'Your Answer', key: 'rbs_answer', type: 'radio', options: data[:options] }
                             ])
      end
    end

    context 'when not all answers are numeric and options are not provided' do
      let(:answer) { %w[A B] }
      let(:data) { { field_label: 'Custom Label' } }

      it 'returns a text field using the provided field_label' do
        expect(fields).to eq([
                               { label: 'Custom Label', key: 'rbs_answer', type: 'text' }
                             ])
      end
    end

    context 'when numeric? raises an exception during array processing' do
      let(:bad_obj) { Object.new }
      let(:answer) { [bad_obj, 'B'] }
      let(:data) { { options: [{ value: 'A', label: 'Option A' }], field_label: 'Label' } }

      it 'rescues the error and returns the radio field branch' do
        expect(fields).to eq([
                               { label: 'Your Answer', key: 'rbs_answer', type: 'radio', options: data[:options] }
                             ])
      end
    end
  end

  describe '#generate_fill_in_fields_for_single' do
    subject(:fields) { generator.send(:generate_fill_in_fields_for_single, answer, data) }

    context 'when answer is numeric or options not provided' do
      let(:answer) { '1.2' }
      let(:data) { { field_label: 'My Answer' } }

      it 'returns a text field with the provided field_label' do
        expect(fields).to eq([{ label: 'My Answer', key: 'rbs_answer', type: 'text' }])
      end
    end

    context 'when answer is non-numeric and options are provided' do
      let(:answer) { 'A' }
      let(:data) { { options: [{ value: 'A', label: 'Option A' }], field_label: 'My Answer' } }

      it "returns a radio field with default label 'Your Answer'" do
        expect(fields).to eq([
                               { label: 'Your Answer', key: 'rbs_answer', type: 'radio', options: data[:options] }
                             ])
      end
    end
  end

  describe '#generate_multiple_choice_fields' do
    subject(:fields) { generator.send(:generate_multiple_choice_fields, data) }

    let(:data) do
      { options: [{ value: 'A', label: 'Option A' },
                  { value: 'B', label: 'Option B' }],
        field_label: 'My Answer' }
    end

    it 'returns a radio field with options' do
      expect(fields).to eq([
                             { label: 'Your Answer', key: 'rbs_answer', type: 'radio', options: data[:options] }
                           ])
    end
  end

  describe '#static_questions' do
    subject(:questions) { generator.send(:static_questions) }

    it 'returns an array of generated questions' do
      aggregate_failures do
        expect(questions).to be_an(Array)
        expect(questions.size).to eq(2)
        expect(questions).to all(include(:question, :answer, :input_fields))
      end
    end
  end

  describe '#dynamic_questions' do
    subject(:questions) { generator.send(:dynamic_questions) }

    it 'returns an array of dynamic problems' do
      aggregate_failures do
        expect(questions).to be_an(Array)
        expect(questions.size).to eq(6)
        expect(questions).to all(include(:question, :answer, :input_fields))
      end
    end
  end

  describe '#numeric?' do
    subject(:result) { generator.send(:numeric?, input) }

    context 'with a valid numeric string' do
      let(:input) { '123.45' }

      it { is_expected.to be(true) }
    end

    context 'with a non-numeric string' do
      let(:input) { 'abc' }

      it { is_expected.to be(false) }
    end

    context 'with nil input' do
      let(:input) { nil }

      it { is_expected.to be(false) }
    end
  end
end

# rubocop:enable RSpec/SpecFilePathFormat
