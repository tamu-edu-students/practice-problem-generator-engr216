require 'rails_helper'

RSpec.describe FiniteDifferences::Base do
  let(:test_class) do
    Class.new do
      include FiniteDifferences::Base
    end
  end

  let(:base) { test_class.new }

  describe '#format_decimal' do
    it 'formats whole numbers without decimal part' do
      expect(base.format_decimal(5.0)).to eq('5')
    end

    it 'formats numbers with a short decimal part correctly' do
      expect(base.format_decimal(3.14)).to eq('3.14')
    end

    it 'truncates long floating point numbers appropriately' do
      expect(base.format_decimal(0.3000000000000004)).to eq('0.3')
    end
  end

  describe '#forward_difference' do
    it 'calculates forward difference correctly' do
      expect(base.forward_difference(2, 6, 2)).to eq(2)
    end
  end

  describe '#backward_difference' do
    it 'calculates backward difference correctly' do
      expect(base.backward_difference(6, 2, 2)).to eq(2)
    end
  end

  describe '#centered_difference' do
    it 'calculates centered difference correctly' do
      expect(base.centered_difference(8, 4, 2)).to eq(1)
    end
  end

  describe '#build_finite_differences_problem' do
    it 'builds a problem with the correct type' do
      problem = base.build_finite_differences_problem('Test question', 42, params: {}, template_id: 1)
      expect(problem[:type]).to eq('finite_differences')
    end

    it 'assigns the correct question text' do
      problem = base.build_finite_differences_problem('Test question', 42, params: {}, template_id: 1)
      expect(problem[:question]).to eq('Test question')
    end

    it 'assigns the correct answer' do
      problem = base.build_finite_differences_problem('Test question', 42, params: {}, template_id: 1)
      expect(problem[:answer]).to eq(42)
    end

    it 'includes a data table when provided' do
      data_table = [['x', '0', '1'], ['f(x)', '0', '1']]
      problem = base.build_finite_differences_problem('Test question', 42, params: { data_table: data_table },
                                                                           template_id: 1)
      expect(problem[:data_table]).to eq(data_table)
    end
  end

  describe '#default_input_field' do
    let(:input_field) { base.default_input_field }

    it 'returns an array' do
      expect(input_field).to be_an(Array)
    end

    it 'has a single input field' do
      expect(input_field.length).to eq(1)
    end

    it 'has the correct label' do
      field = input_field.first
      expect(field[:label]).to eq('Answer')
    end

    it 'has the correct key' do
      field = input_field.first
      expect(field[:key]).to eq('answer')
    end
  end

  describe '#term_without_sign' do
    context 'with power 0' do
      it 'returns just the coefficient as a string' do
        expect(base.term_without_sign(5, 0)).to eq('5')
      end
    end

    context 'with power 1' do
      it 'returns coefficient and x when coefficient is not 1' do
        expect(base.term_without_sign(3, 1)).to eq('3x')
      end

      it 'returns just x when coefficient is 1' do
        expect(base.term_without_sign(1, 1)).to eq('x')
      end
    end

    context 'with power greater than 1' do
      it 'returns coefficient, x, and power when coefficient is not 1' do
        expect(base.term_without_sign(4, 2)).to eq('4x^2')
      end

      it 'returns x and power when coefficient is 1' do
        expect(base.term_without_sign(1, 3)).to eq('x^3')
      end
    end
  end
end
