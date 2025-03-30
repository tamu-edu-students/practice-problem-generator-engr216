require 'rails_helper'

RSpec.describe ErrorPropagationQuestionText do
  describe '.format_formula' do
    context 'with already formatted HTML' do
      it 'returns the formula unchanged' do
        formula = 'x<sup>2</sup> + y<sub>1</sub>'
        expect(described_class.format_formula(formula)).to eq(formula)
      end
    end

    context 'with square roots' do
      it 'formats simple square roots with wrapper' do
        formula = '√x'
        formatted = described_class.format_formula(formula)
        expect(formatted).to include('<span class="sqrt">')
      end

      it 'formats simple square roots with content' do
        formula = '√x'
        formatted = described_class.format_formula(formula)
        expect(formatted).to include('<span class="sqrt-content">x</span>')
      end

      it 'formats square roots with parentheses wrapper' do
        formula = '√(a+b)'
        formatted = described_class.format_formula(formula)
        expect(formatted).to include('<span class="sqrt">')
      end

      it 'formats square roots with parentheses content' do
        formula = '√(a+b)'
        formatted = described_class.format_formula(formula)
        expect(formatted).to include('<span class="sqrt-content">a+b</span>')
      end

      it 'formats double square roots' do
        formula = '√√(x+y)'
        formatted = described_class.format_formula(formula)
        expect(formatted).to include('<span class="sqrt"><span class="sqrt">')
      end
    end

    context 'with fractions' do
      it 'formats simple fractions in parentheses - fraction wrapper' do
        formula = '(1/2)'
        formatted = described_class.format_formula(formula)
        expect(formatted).to include('<span class="fraction">')
      end

      it 'formats simple fractions in parentheses - numerator' do
        formula = '(1/2)'
        formatted = described_class.format_formula(formula)
        expect(formatted).to include('<span class="numerator">1</span>')
      end

      it 'formats simple fractions in parentheses - denominator' do
        formula = '(1/2)'
        formatted = described_class.format_formula(formula)
        expect(formatted).to include('<span class="denominator">2</span>')
      end

      it 'formats complex fractions in parentheses' do
        formula = '(a+b/c+d)'
        formatted = described_class.format_formula(formula)
        expect(formatted).to include('<span class="fraction">')
      end

      it 'formats simple fractions without parentheses' do
        formula = 'x/y'
        formatted = described_class.format_formula(formula)
        expect(formatted).to include('<span class="math-fraction">x/y</span>')
      end
    end

    context 'with exponents' do
      it 'formats superscripts for exponents' do
        formula = 'x^2'
        formatted = described_class.format_formula(formula)
        expect(formatted).to include('x<sup>2</sup>')
      end
    end

    context 'with subscripts' do
      it 'formats subscripts' do
        formula = 'x_i'
        formatted = described_class.format_formula(formula)
        expect(formatted).to include('x<sub>i</sub>')
      end
    end

    context 'with Greek letters' do
      it 'replaces theta with symbol' do
        formula = 'theta'
        formatted = described_class.format_formula(formula)
        expect(formatted).to include('θ')
      end

      it 'replaces pi with symbol' do
        formula = 'pi'
        formatted = described_class.format_formula(formula)
        expect(formatted).to include('π')
      end
    end
  end

  describe '.single_variable_template' do
    let(:constant_info) { { symbol: 'g', value: '9.81', units: 'm/s²' } }
    let(:apparatus) { 'a pendulum' }
    let(:formula) { 'T = 2π√(L/g)' }
    let(:variable) { 'L' }
    let(:value) { 1.0 }
    let(:uncertainty) { 0.1 }
    let(:units) { 'm' }
    let(:field) { 'period' }

    it 'generates template with apparatus info' do
      template = described_class.single_variable_template(
        apparatus, formula, variable, value, uncertainty, units, field
      )
      expect(template).to include(apparatus)
    end

    it 'generates template with variable info' do
      template = described_class.single_variable_template(
        apparatus, formula, variable, value, uncertainty, units, field
      )
      expect(template).to include("#{variable} = #{value} ± #{uncertainty} #{units}")
    end

    it 'generates template with field info' do
      template = described_class.single_variable_template(
        apparatus, formula, variable, value, uncertainty, units, field
      )
      expect(template).to include(field)
    end

    it 'accepts constant information parameter' do
      template = described_class.single_variable_template(
        apparatus, formula, variable, value, uncertainty, units, field, constant_info
      )
      expect(template).to include("Use #{constant_info[:symbol]} = #{constant_info[:value]} #{constant_info[:units]}")
    end
  end

  describe '.multi_variable_template' do
    let(:apparatus) { 'area of a rectangle' }
    let(:formula) { 'A = L × W' }

    let(:variable_data) do
      {
        var1: 'L',
        val1: 10.0,
        unc1: 0.5,
        unit1: 'm',
        var2: 'W',
        val2: 5.0,
        unc2: 0.2,
        unit2: 'm'
      }
    end

    it 'generates template with first variable info' do
      template = described_class.multi_variable_template(
        apparatus, formula, variable_data
      )
      expect(template).to include('L = 10.0 ± 0.5 m')
    end

    it 'generates template with second variable info' do
      template = described_class.multi_variable_template(
        apparatus, formula, variable_data
      )
      expect(template).to include('W = 5.0 ± 0.2 m')
    end
  end

  describe '.fractional_error_template' do
    it 'generates a properly formatted question template' do
      template = described_class.fractional_error_template(
        'kinetic energy',
        'KE = (1/2)mv²',
        'v',
        5
      )
      expect(template).to include('uncertainty of v is 5%')
    end
  end

  describe '.single_variable_explanation' do
    it 'includes the correct value' do
      explanation = described_class.single_variable_explanation(
        'y = x²',
        '2x',
        'x',
        3.0,
        0.1,
        0.6
      )
      expect(explanation).to include('0.6')
    end
  end

  describe '.multi_variable_explanation' do
    it 'includes the correct value' do
      explanation = described_class.multi_variable_explanation(
        'A = L × W',
        %w[W L],
        [10.0, 5.0],
        [0.5, 0.2],
        2.5
      )
      expect(explanation).to include('2.5')
    end
  end

  describe '.fractional_error_explanation' do
    it 'includes the correct percentage' do
      explanation = described_class.fractional_error_explanation(
        'KE = (1/2)mv²',
        'v',
        2.0,
        10.0
      )
      expect(explanation).to include('10.0%')
    end
  end
end
