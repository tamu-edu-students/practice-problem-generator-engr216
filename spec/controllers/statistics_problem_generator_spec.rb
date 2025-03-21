require 'rails_helper'

RSpec.describe StatisticsProblemGenerator do
  # Use a simple string for the category instead of a Category instance
  let(:category) { 'Experimental Statistics' }
  let(:generator) { described_class.new(category) }

  describe '#generate_questions' do
    subject(:questions) { generator.generate_questions }

    it 'returns an array with exactly two problems' do
      expect(questions.length).to eq(2)
    end

    it 'returns a probability problem as the first element' do
      expect(questions[0][:type]).to eq('probability')
    end

    it 'returns a data statistics problem as the second element' do
      expect(questions[1][:type]).to eq('data_statistics')
    end
  end

  describe '#generate_questions implementation details' do
    let(:questions) { generator.generate_questions }

    it 'returns an array of questions' do
      expect(questions).to be_an(Array)
    end

    it 'includes both probability and data_statistics type questions' do
      question_types = questions.map { |q| q[:type] }
      expect(question_types).to include('probability')
    end

    it 'formats data_statistics questions correctly' do
      data_question = questions.find { |q| q[:type] == 'data_statistics' }
      expect(data_question[:answers]).to have_key(:variance)
    end

    it 'formats probability questions correctly' do
      prob_question = questions.find { |q| q[:type] == 'probability' }
      expect(prob_question).to have_key(:answer)
    end
  end

  describe 'probability problem generators' do
    describe '#generate_machine_repair_problem' do
      subject(:problem) { generator.send(:generate_machine_repair_problem) }

      it 'has the probability type' do
        expect(problem[:type]).to eq('probability')
      end

      it 'includes "repair time" in the question' do
        expect(problem[:question]).to include('repair time')
      end

      it 'includes formatting instructions' do
        expect(problem[:question]).to include('Your answer should be a number between 0.0 and 100.0')
      end

      it 'provides a float answer' do
        expect(problem[:answer]).to be_a(Float)
      end

      it 'provides an answer between 0 and 100' do
        expect(problem[:answer]).to be_between(0, 100)
      end
    end

    it 'produce weight problem has probability type' do
      problem = generator.send(:generate_produce_weight_problem)
      expect(problem[:type]).to eq('probability')
    end

    it 'produce weight problem includes weight text in question' do
      problem = generator.send(:generate_produce_weight_problem)
      expect(problem[:question]).to include('weight of produce')
    end

    it 'produce weight problem has a float answer' do
      problem = generator.send(:generate_produce_weight_problem)
      expect(problem[:answer]).to be_a(Float)
    end

    it 'assembly line problem has probability type' do
      problem = generator.send(:generate_assembly_line_problem)
      expect(problem[:type]).to eq('probability')
    end

    it 'assembly line problem includes assembly line text' do
      problem = generator.send(:generate_assembly_line_problem)
      expect(problem[:question]).to include('assembly line')
    end

    it 'assembly line problem has a float answer' do
      problem = generator.send(:generate_assembly_line_problem)
      expect(problem[:answer]).to be_a(Float)
    end

    it 'battery lifespan problem has probability type' do
      problem = generator.send(:generate_battery_lifespan_problem)
      expect(problem[:type]).to eq('probability')
    end

    it 'battery lifespan problem mentions battery in the question' do
      problem = generator.send(:generate_battery_lifespan_problem)
      expect(problem[:question]).to include('battery')
    end

    it 'battery lifespan problem provides a float answer' do
      problem = generator.send(:generate_battery_lifespan_problem)
      expect(problem[:answer]).to be_a(Float)
    end

    it 'customer wait time problem has probability type' do
      problem = generator.send(:generate_customer_wait_time_problem)
      expect(problem[:type]).to eq('probability')
    end

    it 'customer wait time problem mentions wait time in the question' do
      problem = generator.send(:generate_customer_wait_time_problem)
      expect(problem[:question]).to include('wait time')
    end

    it 'customer wait time problem provides a float answer' do
      problem = generator.send(:generate_customer_wait_time_problem)
      expect(problem[:answer]).to be_a(Float)
    end

    it 'package weight problem has probability type' do
      problem = generator.send(:generate_package_weight_problem)
      expect(problem[:type]).to eq('probability')
    end

    it 'package weight problem mentions package in the question' do
      problem = generator.send(:generate_package_weight_problem)
      expect(problem[:question]).to include('package')
    end

    it 'package weight problem provides a float answer' do
      problem = generator.send(:generate_package_weight_problem)
      expect(problem[:answer]).to be_a(Float)
    end

    it 'exam score problem has probability type' do
      problem = generator.send(:generate_exam_score_problem)
      expect(problem[:type]).to eq('probability')
    end

    it 'exam score problem mentions exam in the question' do
      problem = generator.send(:generate_exam_score_problem)
      expect(problem[:question]).to include('exam')
    end

    it 'exam score problem provides a float answer' do
      problem = generator.send(:generate_exam_score_problem)
      expect(problem[:answer]).to be_a(Float)
    end

    it 'component lifetime problem has probability type' do
      problem = generator.send(:generate_component_lifetime_problem)
      expect(problem[:type]).to eq('probability')
    end

    it 'component lifetime problem mentions component in the question' do
      problem = generator.send(:generate_component_lifetime_problem)
      expect(problem[:question]).to include('component')
    end

    it 'component lifetime problem provides a float answer' do
      problem = generator.send(:generate_component_lifetime_problem)
      expect(problem[:answer]).to be_a(Float)
    end

    it 'medication dosage problem has probability type' do
      problem = generator.send(:generate_medication_dosage_problem)
      expect(problem[:type]).to eq('probability')
    end

    it 'medication dosage problem mentions medication in the question' do
      problem = generator.send(:generate_medication_dosage_problem)
      expect(problem[:question]).to include('medication')
    end

    it 'medication dosage problem provides a float answer' do
      problem = generator.send(:generate_medication_dosage_problem)
      expect(problem[:answer]).to be_a(Float)
    end
  end

  describe 'data statistics problem generator' do
    it 'generates data statistics type problem' do
      problem = generator.send(:generate_data_statistics_problem)
      expect(problem[:type]).to eq('data_statistics')
    end

    it 'includes data table in problem' do
      problem = generator.send(:generate_data_statistics_problem)
      expect(problem[:data_table]).to be_an(Array)
    end

    it 'includes answers hash with statistics' do
      problem = generator.send(:generate_data_statistics_problem)
      expect(problem[:answers]).to include(:mean, :median, :mode, :range, :std_dev, :variance)
    end

    it 'includes input fields for all statistics' do
      problem = generator.send(:generate_data_statistics_problem)
      expect(problem[:input_fields].map do |f|
        f[:key]
      end).to include('mean', 'median', 'mode', 'range', 'std_dev', 'variance')
    end
  end

  describe 'statistical calculation methods' do
    let(:values) { [1.0, 2.0, 3.0, 4.0, 5.0] }
    let(:mean) { 3.0 }

    it 'calculates median correctly for odd number of values' do
      expect(generator.send(:calculate_median, values)).to eq(3.0)
    end

    it 'calculates median correctly for even number of values' do
      expect(generator.send(:calculate_median, [1.0, 2.0, 3.0, 4.0])).to eq(2.5)
    end

    it 'calculates mode correctly for uniform distribution' do
      expect(generator.send(:calculate_mode, values)).to eq(1.0)
    end

    it 'calculates mode correctly for non-uniform distribution' do
      expect(generator.send(:calculate_mode, [1.0, 2.0, 2.0, 3.0])).to eq(2.0)
    end

    it 'calculates variance correctly' do
      expect(generator.send(:calculate_variance, values, mean)).to be_within(0.01).of(2.0)
    end
  end

  describe '#initialize' do
    it 'sets the category' do
      expect(generator.instance_variable_get(:@category)).to eq('Experimental Statistics')
    end
  end
end
