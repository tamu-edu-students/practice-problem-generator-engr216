# frozen_string_literal: true

# rubocop:disable RSpec/SpecFilePathFormat, Naming/VariableNumber

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

# Subclass to override field generation methods for tests of generate_rbs_problem_from_data.
class TestRigidBodyStaticsProblemGeneratorWithStubbedFields < TestRigidBodyStaticsProblemGenerator
  def generate_fill_in_fields(_data)
    [{ key: 'rbs_answer', type: 'text' }]
  end

  def generate_multiple_choice_fields(_data)
    [{ key: 'rbs_answer', type: 'radio', options: %w[A B] }]
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
    let(:data) do
      {
        question: 'Test question?',
        answer: 'Test answer',
        input_type: input_type,
        image: 'test.png'
      }
    end

    context "when input_type is 'fill_in'" do
      # Use the subclass that overrides generate_fill_in_fields.
      subject(:generator) { TestRigidBodyStaticsProblemGeneratorWithStubbedFields.new('Rigid Body Statics') }

      let(:input_type) { 'fill_in' }

      it 'returns a hash with the expected keys' do
        result = generator.send(:generate_rbs_problem_from_data, data)
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
      # Use the subclass that overrides generate_multiple_choice_fields.
      subject(:generator) { TestRigidBodyStaticsProblemGeneratorWithStubbedFields.new('Rigid Body Statics') }

      let(:input_type) { 'multiple_choice' }

      it 'returns a hash using generate_multiple_choice_fields' do
        result = generator.send(:generate_rbs_problem_from_data, data)
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
      let(:data) { { answer: ['1.2', '3.4'], field_label: 'My Answer' } }

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
        {
          options: [{ value: 'A', label: 'Option A' }, { value: 'B', label: 'Option B' }],
          field_label: 'Label'
        }
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
      {
        options: [{ value: 'A', label: 'Option A' }, { value: 'B', label: 'Option B' }],
        field_label: 'My Answer'
      }
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

  describe '#dynamic_problem_1' do
    let(:problem) { generator.send(:dynamic_problem_1) }

    it 'generates a valid beam problem' do
      expect(problem).to include(
        type: 'rigid_body_statics',
        input_fields: be_an(Array)
      )
      expect(problem[:question]).to include('A horizontal beam ABCD is supported by a pin at A and a roller at D')
      expect(problem[:image]).to eq('rigid1.png')
    end
  end

  describe '#dynamic_problem_2' do
    let(:problem) { generator.send(:dynamic_problem_2) }

    it 'generates a valid cable tension problem' do
      expect(problem).to include(
        type: 'rigid_body_statics',
        input_fields: be_an(Array)
      )
      expect(problem[:question]).to include('Cables AC and BC are tied together at C and are loaded as shown')
      expect(problem[:image]).to eq('rigid2.png')
    end
  end

  describe '#dynamic_problem_3' do
    let(:problem) { generator.send(:dynamic_problem_3) }

    it 'generates a valid cable tension problem with alpha angle' do
      expect(problem).to include(
        type: 'rigid_body_statics',
        input_fields: be_an(Array)
      )
      expect(problem[:question]).to include('In the figure below, if the angle α (alpha) is')
      expect(problem[:image]).to eq('rigid3.png')
    end
  end

  describe '#dynamic_problem_4' do
    let(:problem) { generator.send(:dynamic_problem_4) }

    it 'generates a valid coordinates problem' do
      expect(problem).to include(
        type: 'rigid_body_statics',
        input_fields: be_an(Array)
      )
      expect(problem[:question]).to include('Determine the magnitude of the moment of this force')
      expect(problem[:answer]).to be_present
    end
  end

  describe '#dynamic_problem_5' do
    let(:problem) { generator.send(:dynamic_problem_5) }

    it 'generates a valid problem with force calculation' do
      expect(problem).to include(
        type: 'rigid_body_statics', # corrected the expected value here
        input_fields: be_an(Array)
      )
      expect(problem[:answer]).to be_present
    end
  end

  describe '#dynamic_problem_6' do
    let(:problem) { generator.send(:dynamic_problem_6) }

    it 'generates a valid force and weight calculation problem' do
      expect(problem).to include(
        type: 'rigid_body_statics',
        input_fields: be_an(Array)
      )
      expect(problem[:question]).to include('Find the moment about Point B due to the force F')
      expect(problem[:answer]).to be_present
    end
  end
end

# rubocop:enable RSpec/SpecFilePathFormat, Naming/VariableNumber
