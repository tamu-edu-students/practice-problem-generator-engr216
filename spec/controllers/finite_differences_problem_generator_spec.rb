require 'rails_helper'

RSpec.describe FiniteDifferencesProblemGenerator do
  let(:category) { 'Finite Differences' }
  let(:generator) { described_class.new(category) }

  describe '#initialize' do
    it 'initializes with the correct category' do
      expect(generator.instance_variable_get(:@category)).to eq(category)
    end

    it 'starts with an empty list of last used generators' do
      expect(generator.instance_variable_get(:@last_used_generators)).to eq([])
    end
  end

  describe '#generate_questions' do
    it 'generates an array with one finite differences problem' do
      allow(generator).to receive(:generate_finite_differences_problem).and_return('test problem')
      expect(generator.generate_questions).to eq(['test problem'])
    end
  end

  describe '#generate_finite_differences_problem' do
    before do
      allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('production'))
    end

    context 'when selecting a generator' do
      let(:available_generators) { %i[polynomial_all_approximations data_table_backward] }
      let(:result) { generator.send(:generate_finite_differences_problem) }

      before do
        allow(generator).to receive_messages(
          available_generator_list: available_generators,
          choose_generator: :polynomial_all_approximations,
          generate_polynomial_all_approximations_problem: {},
          add_debug_info: nil
        )

        result
      end

      it 'calls choose_generator with available generators' do
        expect(generator).to have_received(:choose_generator).with(available_generators)
      end
    end

    context 'when calling generator methods' do
      let(:generator_method) { :polynomial_all_approximations }

      before do
        allow(generator).to receive_messages(
          available_generator_list: [generator_method],
          choose_generator: generator_method
        )
        allow(generator).to receive(:"generate_#{generator_method}_problem").and_return({})
        allow(generator).to receive(:add_debug_info)

        generator.send(:generate_finite_differences_problem)
      end

      it 'invokes the selected generator method' do
        expect(generator).to have_received(:"generate_#{generator_method}_problem")
      end
    end

    context 'when tracking used generators' do
      let(:last_used) { [:polynomial_all_approximations] }
      let(:available_gens) { %i[data_table_backward trig_function_centered] }

      before do
        generator.instance_variable_set(:@last_used_generators, last_used)

        allow(generator).to receive_messages(
          available_generator_list: available_gens,
          choose_generator: :data_table_backward,
          generate_data_table_backward_problem: {}
        )
        allow(generator).to receive(:add_debug_info)

        generator.send(:generate_finite_differences_problem)
      end

      it 'calls the selected generator method' do
        expect(generator).to have_received(:generate_data_table_backward_problem)
      end
    end

    context 'when all generators have been used' do
      let(:all_gen_methods) { generator.send(:generator_methods_list) }
      let(:unused_gen) { :polynomial_all_approximations }
      let(:last_four) { all_gen_methods.take(all_gen_methods.size - 1) }

      before do
        generator.instance_variable_set(:@last_used_generators, last_four)

        allow(generator).to receive_messages(
          verify_generator_methods: all_gen_methods,
          choose_generator: unused_gen
        )
        allow(generator).to receive(:"generate_#{unused_gen}_problem").and_return({})
        allow(generator).to receive(:add_debug_info)

        generator.send(:generate_finite_differences_problem)
      end

      it 'calls the chosen generator method' do
        expect(generator).to have_received(:"generate_#{unused_gen}_problem")
      end
    end

    context 'with multiple answers debug info' do
      let(:problem_data) do
        {
          type: 'finite_differences',
          input_fields: [
            { label: 'Forward Difference', key: 'forward' },
            { label: 'Backward Difference', key: 'backward' },
            { label: 'Centered Difference', key: 'centered' }
          ],
          parameters: {
            forward: 0,
            backward: 20,
            centered: 10
          }
        }
      end
      let(:result) { generator.send(:generate_finite_differences_problem) }

      before do
        allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('development'))

        allow(generator).to receive_messages(
          generate_function_table_all_methods_problem: problem_data,
          choose_generator: :function_table_all_methods,
          available_generator_list: [:function_table_all_methods]
        )
      end

      it 'includes the method name in debug info' do
        expect(result[:debug_info]).to include('Method: function_table_all_methods')
      end

      it 'includes the forward difference in debug info' do
        expect(result[:debug_info]).to include('Forward Difference: 0')
      end

      it 'includes the backward difference in debug info' do
        expect(result[:debug_info]).to include('Backward Difference: 20')
      end

      it 'includes the centered difference in debug info' do
        expect(result[:debug_info]).to include('Centered Difference: 10')
      end
    end
  end

  describe '#available_generator_list' do
    it 'returns a list of verified generators' do
      all_generators = %i[polynomial_all_approximations function_table_all_methods]
      allow(generator).to receive(:generator_methods_list).and_return(all_generators)
      allow(generator).to receive(:verify_generator_methods).with(all_generators).and_return(all_generators)
      allow(generator).to receive(:filter_recently_used_generators).with(all_generators).and_return(all_generators)

      expect(generator.send(:available_generator_list)).to eq(all_generators)
    end
  end

  describe '#generator_methods_list' do
    it 'combines fundamental and advanced generators' do
      fundamental = %i[basic1 basic2]
      advanced = %i[advanced1 advanced2]

      allow(generator).to receive_messages(fundamental_generators: fundamental, advanced_generators: advanced)

      expect(generator.send(:generator_methods_list)).to eq(fundamental + advanced)
    end
  end

  describe '#fundamental_generators' do
    let(:generators) { generator.send(:fundamental_generators) }

    it 'includes basic polynomial generators' do
      expect(generators).to include(:polynomial_all_approximations)
    end

    it 'includes data table generators' do
      expect(generators).to include(:data_table_backward)
    end

    it 'returns an array' do
      expect(generators).to be_an(Array)
    end

    it 'has the correct size' do
      expect(generators.size).to eq(5)
    end
  end

  describe '#advanced_generators' do
    let(:generators) { generator.send(:advanced_generators) }

    it 'includes natural log derivative generators' do
      expect(generators).to include(:natural_log_derivative)
    end

    it 'includes exponential function generators' do
      expect(generators).to include(:exponential_function_derivative)
    end

    it 'returns an array' do
      expect(generators).to be_an(Array)
    end

    it 'has the correct size' do
      expect(generators.size).to eq(5)
    end
  end

  describe '#verify_generator_methods' do
    it 'filters out non-existent methods' do
      all_generators = %i[real_method fake_method]
      allow(generator).to receive(:respond_to?).with(:generate_real_method_problem, true).and_return(true)
      allow(generator).to receive(:respond_to?).with(:generate_fake_method_problem, true).and_return(false)

      expect(generator.send(:verify_generator_methods, all_generators)).to eq([:real_method])
    end
  end

  describe '#filter_recently_used_generators' do
    it 'excludes recently used generators' do
      verified_generators = %i[gen1 gen2 gen3]
      generator.instance_variable_set(:@last_used_generators, [:gen1])

      expect(generator.send(:filter_recently_used_generators, verified_generators)).to eq(%i[gen2 gen3])
    end

    it 'returns all generators when all have been recently used' do
      verified_generators = %i[gen1 gen2]
      generator.instance_variable_set(:@last_used_generators, %i[gen1 gen2])

      expect(generator.send(:filter_recently_used_generators, verified_generators)).to eq(verified_generators)
    end
  end

  describe '#choose_generator' do
    it 'selects a random generator from the available list' do
      available_generators = %i[gen1 gen2 gen3]
      allow(available_generators).to receive(:sample).and_return(:gen2)

      expect(generator.send(:choose_generator, available_generators)).to eq(:gen2)
    end

    it 'adds the selected generator to last_used_generators' do
      available_generators = %i[gen1 gen2 gen3]
      allow(available_generators).to receive(:sample).and_return(:gen2)

      generator.send(:choose_generator, available_generators)
      expect(generator.instance_variable_get(:@last_used_generators)).to include(:gen2)
    end

    context 'when limiting generators' do
      let(:old_generators) { %i[gen1 gen2 gen3 gen4 gen5] }
      let(:new_generator) { :gen6 }
      let(:available_generators) { [new_generator] }

      before do
        generator.instance_variable_set(:@last_used_generators, old_generators)
      end

      it 'maintains a maximum of five tracked generators' do
        allow(available_generators).to receive(:sample).and_return(new_generator)
        generator.send(:choose_generator, available_generators)
        last_used = generator.instance_variable_get(:@last_used_generators)

        expect(last_used.size).to eq(5)
      end

      it 'includes the newly chosen generator' do
        allow(available_generators).to receive(:sample).and_return(new_generator)
        generator.send(:choose_generator, available_generators)
        last_used = generator.instance_variable_get(:@last_used_generators)

        expect(last_used).to include(new_generator)
      end

      it 'removes the oldest generator' do
        allow(available_generators).to receive(:sample).and_return(new_generator)
        generator.send(:choose_generator, available_generators)
        last_used = generator.instance_variable_get(:@last_used_generators)

        expect(last_used).not_to include(:gen1)
      end
    end
  end

  describe '#add_debug_info' do
    context 'with a single answer' do
      let(:problem) do
        {
          answer: 42,
          input_fields: [{ label: 'Answer', key: 'answer' }]
        }
      end

      before do
        generator.send(:add_debug_info, problem, :test_generator)
      end

      it 'includes the generator method in debug info' do
        expect(problem[:debug_info]).to include('Method: test_generator')
      end

      it 'includes the correct answer in debug info' do
        expect(problem[:debug_info]).to include('Correct answer: 42')
      end
    end

    context 'with multiple answers' do
      let(:problem) do
        {
          parameters: {
            forward: 10,
            backward: 20
          },
          input_fields: [
            { label: 'Forward', key: 'forward' },
            { label: 'Backward', key: 'backward' }
          ]
        }
      end

      before do
        generator.send(:add_debug_info, problem, :test_generator)
      end

      it 'includes the generator method in debug info' do
        expect(problem[:debug_info]).to include('Method: test_generator')
      end

      it 'includes the forward value in debug info' do
        expect(problem[:debug_info]).to include('Forward: 10')
      end

      it 'includes the backward value in debug info' do
        expect(problem[:debug_info]).to include('Backward: 20')
      end
    end
  end

  describe '#build_finite_differences_problem' do
    let(:question_text) { 'What is the derivative of f(x) = x^2 at x = 2?' }
    let(:answer) { 4 }
    let(:result) do
      generator.send(:build_finite_differences_problem, question_text, answer, params: {}, template_id: 1)
    end

    it 'sets the correct problem type' do
      expect(result[:type]).to eq('finite_differences')
    end

    it 'includes the question text' do
      expect(result[:question]).to eq(question_text)
    end

    it 'includes the correct answer' do
      expect(result[:answer]).to eq(answer)
    end
  end

  describe '#build_finite_differences_problem with custom fields' do
    let(:question_text) { 'What is the derivative of f(x) = x^2 at x = 2?' }
    let(:answer) { 4 }
    let(:custom_fields) do
      [
        { label: 'Derivative at x=1', key: 'deriv_1' },
        { label: 'Derivative at x=2', key: 'deriv_2' }
      ]
    end

    it 'uses the provided input fields' do
      result = generator.send(:build_finite_differences_problem, question_text, answer,
                              params: { input_fields: custom_fields }, template_id: 1)

      expect(result[:input_fields]).to eq(custom_fields)
    end
  end

  describe '#build_finite_differences_problem with data table' do
    let(:question_text) { 'What is the derivative of f(x) = x^2 at x = 2?' }
    let(:answer) { 4 }
    let(:data_table) do
      [
        ['x', '1', '2', '3'],
        ['f(x)', '1', '4', '9']
      ]
    end

    it 'includes the data table in the problem' do
      result = generator.send(:build_finite_differences_problem, question_text, answer,
                              params: { data_table: data_table }, template_id: 1)

      expect(result[:data_table]).to eq(data_table)
    end
  end

  describe '#default_input_field' do
    let(:fields) { generator.send(:default_input_field) }

    it 'returns an array object' do
      expect(fields).to be_an(Array)
    end

    it 'contains exactly one item' do
      expect(fields.size).to eq(1)
    end

    it 'has the correct label' do
      field = fields.first
      expect(field[:label]).to eq('Answer')
    end

    it 'has the correct key' do
      field = fields.first
      expect(field[:key]).to eq('answer')
    end
  end

  describe '#forward_difference' do
    it 'calculates the forward difference correctly' do
      expect(generator.send(:forward_difference, 4, 9, 1)).to eq(5)
    end

    it 'works with float values' do
      expect(generator.send(:forward_difference, 4.5, 9.5, 1)).to eq(5)
    end
  end

  describe '#backward_difference' do
    it 'calculates the backward difference correctly' do
      expect(generator.send(:backward_difference, 9, 4, 1)).to eq(5)
    end

    it 'works with float values' do
      expect(generator.send(:backward_difference, 9.5, 4.5, 1)).to eq(5)
    end
  end

  describe '#centered_difference' do
    it 'calculates the centered difference correctly' do
      expect(generator.send(:centered_difference, 9, 1, 2)).to eq(2)
    end

    it 'works with float values' do
      expect(generator.send(:centered_difference, 9.5, 1.5, 2)).to eq(2)
    end
  end

  describe '#polynomial_derivative' do
    it 'calculates the derivative of a polynomial correctly' do
      coefficients = [3, 2, 5, 0] # 3 + 2x + 5x^2
      x_val = 2

      # For f(x) = 3 + 2x + 5x^2
      # f'(x) = 2 + 10x
      # f'(2) = 2 + 10*2 = 22
      expected_derivative = 22

      expect(generator.send(:polynomial_derivative, coefficients, x_val)).to eq(expected_derivative)
    end

    it 'skips the constant term' do
      coefficients = [10, 0, 0, 0] # 10
      x_val = 2

      # For f(x) = 10, f'(x) = 0
      expected_derivative = 0

      expect(generator.send(:polynomial_derivative, coefficients, x_val)).to eq(expected_derivative)
    end

    it 'handles higher-degree terms' do
      coefficients = [0, 0, 0, 1] # x^3
      x_val = 2

      # For f(x) = x^3, f'(x) = 3x^2
      # f'(2) = 3*2^2 = 12
      expected_derivative = 12

      expect(generator.send(:polynomial_derivative, coefficients, x_val)).to eq(expected_derivative)
    end
  end
end
