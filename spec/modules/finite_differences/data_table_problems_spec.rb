require 'rails_helper'

RSpec.describe FiniteDifferences::DataTableProblems do
  let(:test_class) do
    Class.new do
      include FiniteDifferences::Base
      include FiniteDifferences::DataTableProblems

      # Stub for the text methods
      def data_table_backward_text(_params)
        'Test backward difference data table question'
      end

      def data_table_forward_text(_params)
        'Test forward difference data table question'
      end

      def velocity_profile_centered_text(_params)
        'Test velocity profile centered difference question'
      end
    end
  end

  let(:data_table) { test_class.new }

  describe '#generate_data_table_backward_problem' do
    before do
      # Stub random values
      allow(data_table).to receive(:rand).and_return(2)
    end

    let(:problem) { data_table.generate_data_table_backward_problem }

    it 'generates a problem with the correct type' do
      expect(problem[:type]).to eq('finite_differences')
    end

    it 'includes the correct question text' do
      expect(problem[:question]).to eq('Test backward difference data table question')
    end

    it 'includes a data table' do
      expect(problem).to have_key(:data_table)
    end

    it 'has the correct number of rows in the data table' do
      expect(problem[:data_table].size).to eq(3) # Header and two data rows
    end
  end

  describe '#generate_data_table_forward_problem' do
    before do
      # Stub random values
      allow(data_table).to receive(:rand).and_return(2)
    end

    let(:problem) { data_table.generate_data_table_forward_problem }

    it 'generates a problem with the correct type' do
      expect(problem[:type]).to eq('finite_differences')
    end

    it 'includes the correct question text' do
      expect(problem[:question]).to eq('Test forward difference data table question')
    end

    it 'includes a data table' do
      expect(problem).to have_key(:data_table)
    end

    it 'has the correct number of rows in the data table' do
      expect(problem[:data_table].size).to eq(3) # Header and two data rows
    end
  end

  describe '#generate_velocity_profile_centered_problem' do
    before do
      # Stub random values
      allow(data_table).to receive(:rand).and_return(2)
    end

    let(:problem) { data_table.generate_velocity_profile_centered_problem }

    it 'generates a problem with the correct type' do
      expect(problem[:type]).to eq('finite_differences')
    end

    it 'includes the correct question text' do
      expect(problem[:question]).to eq('Test velocity profile centered difference question')
    end

    it 'includes a data table' do
      expect(problem).to have_key(:data_table)
    end

    it 'has the correct number of rows in the data table' do
      expect(problem[:data_table].size).to eq(2) # Position and velocity rows
    end
  end

  # Test private methods
  describe 'private methods' do
    describe '#generate_cooling_data' do
      before do
        allow(data_table).to receive(:rand).and_return(2)
      end

      let(:data) { data_table.send(:generate_cooling_data) }

      it 'includes time data' do
        expect(data).to have_key(:times)
      end

      it 'includes temperature data' do
        expect(data).to have_key(:temperatures)
      end

      it 'generates the correct number of time points' do
        expect(data[:times].size).to eq(5)
      end

      it 'generates the correct number of temperature points' do
        expect(data[:temperatures].size).to eq(5)
      end

      it 'generates decreasing temperatures' do
        expect(data[:temperatures][0]).to be > data[:temperatures][4]
      end
    end

    it 'calculates backward difference from data correctly' do
      temperatures = [100, 95, 90, 85, 80]
      point = 2 # Third element (90)
      step_size = 1

      diff = data_table.send(:calculate_backward_diff_from_data, temperatures, point, step_size)

      # (90 - 95) / 1 = -5
      expect(diff).to eq(-5)
    end

    it 'calculates forward difference from data correctly' do
      temperatures = [100, 95, 90, 85, 80]
      point = 2 # Third element (90)
      step_size = 1

      diff = data_table.send(:calculate_forward_diff_from_data, temperatures, point, step_size)

      # (85 - 90) / 1 = -5
      expect(diff).to eq(-5)
    end

    it 'calculates centered difference from data correctly' do
      temperatures = [100, 95, 90, 85, 80]
      point = 2 # Third element (90)
      step_size = 1

      diff = data_table.send(:calculate_centered_diff_from_data, temperatures, point, step_size)

      # (85 - 95) / (2 * 1) = -5
      expect(diff).to eq(-5)
    end
  end
end
