require 'rails_helper'

RSpec.describe FiniteDifferencesProblemGenerator, type: :model do
  let(:generator) { described_class.new('Finite Differences') }
  
  describe '#generate_questions' do
    it 'returns an array with a finite differences problem' do
      questions = generator.generate_questions
      expect(questions).to be_an(Array)
      expect(questions.length).to eq(1)
      expect(questions.first[:type]).to eq('finite_differences')
    end
  end
  
  describe '#generate_finite_differences_problem' do
    it 'generates a random finite differences problem' do
      # Allow any of the problem generator methods to be called
      allow(generator).to receive(:generate_polynomial_all_approximations_problem).and_return({})
      allow(generator).to receive(:generate_data_table_backward_problem).and_return({})
      allow(generator).to receive(:generate_trig_function_centered_problem).and_return({})
      # And all other problem types
      
      expect { generator.send(:generate_finite_differences_problem) }.not_to raise_error
    end
  end
  
  # Test a specific problem generator method
  describe '#generate_polynomial_all_approximations_problem' do
    it 'generates a polynomial problem with all approximation methods' do
      problem = generator.send(:generate_polynomial_all_approximations_problem)
      
      expect(problem[:type]).to eq('finite_differences')
      expect(problem[:question]).to include('approximations')
      expect(problem[:input_fields].length).to eq(4) # All 4 fields
      
      # Verify parameters are present
      parameters = problem[:parameters]
      expect(parameters).to have_key(:forward_diff)
      expect(parameters).to have_key(:backward_diff)
      expect(parameters).to have_key(:centered_diff)
      expect(parameters).to have_key(:true_derivative)
    end
  end
  
  # Test helper methods
  describe '#forward_difference' do
    it 'correctly calculates forward difference' do
      f_x = 4
      f_x_plus_h = 9
      h = 1
      
      result = generator.send(:forward_difference, f_x, f_x_plus_h, h)
      expect(result).to eq(5) # The slope of f(x) = x² at x = 2 is 4
    end
  end
  
  describe '#backward_difference' do
    it 'correctly calculates backward difference' do
      f_x = 4
      f_x_minus_h = 1
      h = 1
      
      result = generator.send(:backward_difference, f_x, f_x_minus_h, h)
      expect(result).to eq(3) # The approximate slope of f(x) = x² at x = 2 using backward diff
    end
  end
  
  describe '#centered_difference' do
    it 'correctly calculates centered difference' do
      f_x_plus_h = 9
      f_x_minus_h = 1
      h = 1
      
      result = generator.send(:centered_difference, f_x_plus_h, f_x_minus_h, h)
      expect(result).to eq(4) # The exact slope of f(x) = x² at x = 2 is 4
    end
  end
end 