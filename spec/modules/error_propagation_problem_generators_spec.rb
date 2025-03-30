require 'rails_helper'

RSpec.describe ErrorPropagationProblemGenerators do
  describe '.single_variable_problems' do
    it 'returns an array' do
      problems = described_class.single_variable_problems
      expect(problems).to be_an(Array)
    end

    it 'returns non-empty array' do
      problems = described_class.single_variable_problems
      expect(problems).not_to be_empty
    end
  end

  describe '.multi_variable_problems' do
    it 'returns an array' do
      problems = described_class.multi_variable_problems
      expect(problems).to be_an(Array)
    end

    it 'returns non-empty array' do
      problems = described_class.multi_variable_problems
      expect(problems).not_to be_empty
    end
  end

  describe '.fractional_error_problems' do
    it 'returns an array' do
      problems = described_class.fractional_error_problems
      expect(problems).to be_an(Array)
    end

    it 'returns non-empty array' do
      problems = described_class.fractional_error_problems
      expect(problems).not_to be_empty
    end
  end

  # Tests for individual problem generators
  describe '.pendulum_period_problem' do
    let(:problem) { described_class.pendulum_period_problem }

    it 'generates a problem with question and answer' do
      expect(problem).to include(:question, :answer)
    end

    it 'generates a problem with field label and explanation' do
      expect(problem).to include(:field_label, :explanation)
    end

    it 'includes pendulum in question text' do
      expect(problem[:question]).to include('simple pendulum')
    end

    it 'includes correct field label' do
      expect(problem[:field_label]).to include('period')
    end
  end

  describe '.projectile_range_problem' do
    let(:problem) { described_class.projectile_range_problem }

    it 'generates a problem with required keys' do
      expect(problem).to include(:question, :answer, :field_label, :explanation)
    end

    it 'includes projectile in question text' do
      expect(problem[:question]).to include('projectile')
    end

    it 'includes correct field label' do
      expect(problem[:field_label]).to include('range')
    end
  end

  describe '.circular_area_problem' do
    let(:problem) { described_class.circular_area_problem }

    it 'generates a problem with required keys' do
      expect(problem).to include(:question, :answer, :field_label, :explanation)
    end

    it 'includes circular field in question text' do
      expect(problem[:question]).to include('circular field')
    end

    it 'includes correct field label' do
      expect(problem[:field_label]).to include('area')
    end
  end

  describe '.spring_potential_energy_problem' do
    let(:problem) { described_class.spring_potential_energy_problem }

    it 'generates a problem with required keys' do
      expect(problem).to include(:question, :answer, :field_label, :explanation)
    end

    it 'includes compressed spring in question text' do
      expect(problem[:question]).to include('compressed spring')
    end

    it 'includes correct field label' do
      expect(problem[:field_label]).to include('potential energy')
    end
  end

  describe '.density_problem' do
    let(:problem) { described_class.density_problem }

    it 'generates a problem with required keys' do
      expect(problem).to include(:question, :answer, :field_label, :explanation)
    end

    it 'includes density in question text' do
      expect(problem[:question]).to include('density')
    end

    it 'includes correct field label' do
      expect(problem[:field_label]).to include('density')
    end
  end

  describe '.kinetic_energy_fractional_problem' do
    let(:problem) { described_class.kinetic_energy_fractional_problem }

    it 'generates a problem with required keys' do
      expect(problem).to include(:question, :answer, :field_label, :explanation)
    end

    it 'includes kinetic energy in question text' do
      expect(problem[:question]).to include('kinetic energy')
    end

    it 'includes correct field label' do
      expect(problem[:field_label]).to include('energy')
    end

    it 'calculates relative uncertainty correctly' do
      problem = described_class.kinetic_energy_fractional_problem
      v_percentage = problem[:question].match(/uncertainty of v is (\d+)%/)[1].to_i
      expected_result = (2 * v_percentage).to_f
      expect(problem[:answer].to_f).to eq(expected_result)
    end
  end

  describe '.gravitational_force_fractional_problem' do
    let(:problem) { described_class.gravitational_force_fractional_problem }

    it 'generates a problem with required keys' do
      expect(problem).to include(:question, :answer, :field_label, :explanation)
    end

    it 'includes gravitational force in question text' do
      expect(problem[:question]).to include('gravitational force')
    end

    it 'includes correct field label' do
      expect(problem[:field_label]).to include('force')
    end

    it 'calculates relative uncertainty correctly' do
      problem = described_class.gravitational_force_fractional_problem
      r_percentage = problem[:question].match(/uncertainty of r is (\d+)%/)[1].to_i
      expected_result = (2 * r_percentage).to_f
      expect(problem[:answer].to_f).to eq(expected_result)
    end
  end

  describe '.velocity_fractional_problem' do
    let(:problem) { described_class.velocity_fractional_problem }

    it 'generates a problem with required keys' do
      expect(problem).to include(:question, :answer, :field_label, :explanation)
    end

    it 'includes speed in question text' do
      expect(problem[:question]).to include('speed')
    end

    it 'includes correct field label' do
      expect(problem[:field_label]).to include('speed')
    end

    it 'calculates relative uncertainty correctly' do
      problem = described_class.velocity_fractional_problem
      h_percentage = problem[:question].match(/uncertainty of h is (\d+)%/)[1].to_i
      expected_result = (0.5 * h_percentage).to_f
      expect(problem[:answer].to_f).to eq(expected_result)
    end
  end

  describe '.yo_yo_problem' do
    let(:problem) { described_class.yo_yo_problem }

    it 'generates a problem with required keys' do
      expect(problem).to include(:question, :answer, :field_label, :explanation)
    end

    it 'includes yo-yo in question text' do
      expect(problem[:question]).to include("yo-yo's center of mass")
    end

    it 'includes correct field label' do
      expect(problem[:field_label]).to include('speed')
    end

    it 'calculates relative uncertainty correctly' do
      problem = described_class.yo_yo_problem
      h_uncertainty = problem[:question].match(/uncertainty of h is (\d+)%/)[1].to_i
      expected_result = (0.5 * h_uncertainty).to_f
      expect(problem[:answer].to_f).to eq(expected_result)
    end
  end
end
