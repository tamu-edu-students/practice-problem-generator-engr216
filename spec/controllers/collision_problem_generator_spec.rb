require 'rails_helper'

RSpec.describe CollisionProblemGenerator, type: :model do
  let(:category) { 'Momentum & Collisions' }
  let(:generator) { described_class.new(category) }

  describe '#initialize' do
    it 'sets the category attribute' do
      expect(generator.instance_variable_get(:@category)).to eq(category)
    end
  end

  describe '#generate_questions' do
    it 'returns an array with one collision problem' do
      allow(generator).to receive(:generate_collision_problem).and_return({ test: 'problem' })
      questions = generator.generate_questions
      expect(questions).to be_an(Array)
      expect(questions.length).to eq(1)
      expect(questions.first).to eq({ test: 'problem' })
    end
  end

  describe 'physics calculations' do
    it 'correctly calculates momentum' do
      expect(generator.send(:calculate_momentum, 2, 5)).to eq(10)
    end

    it 'correctly calculates kinetic energy' do
      expect(generator.send(:calculate_kinetic_energy, 2, 5)).to eq(25)
    end

    it 'correctly calculates final velocity for first object in elastic collision' do
      result = generator.send(:calculate_final_velocity_elastic_obj1, 2, 5, 3, 0)
      expect(result).to be_within(0.001).of(-1.0)
    end

    it 'correctly calculates final velocity for second object in elastic collision' do
      result = generator.send(:calculate_final_velocity_elastic_obj2, 2, 5, 3, 0)
      expect(result).to be_within(0.001).of(4.0)
    end

    it 'correctly calculates final velocities in inelastic collision' do
      velocities = generator.send(:calculate_final_velocity_inelastic, 2, 5, 3, 0, 0.5)
      expect(velocities).to be_an(Array)
      expect(velocities.length).to eq(2)
      expect(velocities[0]).to be_within(0.001).of(1.5)
      expect(velocities[1]).to be_within(0.001).of(3.5)
    end

    it 'correctly calculates final velocity in perfectly inelastic collision' do
      result = generator.send(:calculate_final_velocity_perfectly_inelastic, 2, 5, 3, 0)
      expect(result).to be_within(0.001).of(2.0)
    end

    it 'correctly calculates energy lost in collision' do
      expect(generator.send(:calculate_energy_lost, 100, 60)).to eq(40)
    end

    it 'correctly calculates velocity from height' do
      result = generator.send(:calculate_velocity_from_height, 10, false)
      expect(result).to be_within(0.001).of(Math.sqrt(2 * 9.8 * 10))

      result = generator.send(:calculate_velocity_from_height, 1000, true)
      expect(result).to be_within(0.001).of(Math.sqrt(2 * 9.8 * 10))
    end

    it 'correctly calculates height from velocity' do
      result = generator.send(:calculate_height_from_velocity, 14, false)
      expect(result).to be_within(0.001).of((14**2) / (2 * 9.8))

      result = generator.send(:calculate_height_from_velocity, 14, true)
      expect(result).to be_within(0.001).of(((14**2) / (2 * 9.8)) * 100)
    end
  end

  describe 'problem handlers' do
    it 'correctly handles bullet block collision problems' do
      result = generator.send(:calculate_bullet_block_collision, 0.01, 400, 100, 5)
      expect(result).to be_within(0.01).of(0.6)
    end

    it 'correctly handles hydrogen atom collision problems' do
      result = generator.send(:calculate_hydrogen_atom_collision, 4)
      expect(result).to be_within(0.01).of(64.0)
    end

    it 'correctly handles soccer ball collision problems' do
      result = generator.send(:calculate_soccer_ball_collision, 0.5, 0.3, 2)
      expect(result).to be > 0
    end

    it 'correctly handles car collision problems' do
      result = generator.send(:calculate_car_collision, 1500, 20, 1200, -15)
      expect(result).to be_within(0.01).of(4.44)
    end

    it 'correctly handles pool ball collision problems' do
      result = generator.send(:calculate_pool_ball_collision, 0.2, 5, 30)
      expect(result).to be_within(0.01).of(2.5)
    end

    it 'correctly handles pendulum collision problems' do
      result = generator.send(:calculate_pendulum_collision, 0.1, 0.2, 20)
      expect(result).to be > 0
    end

    it 'correctly handles puck collision problems' do
      result = generator.send(:calculate_puck_collision, 0.3, 10, 0.3)
      expect(result).to be_a(Hash)
      expect(result[:puck1]).to be_within(0.01).of(0)
      expect(result[:puck2]).to be_within(0.01).of(10)
    end

    it 'correctly handles projectile collision problems' do
      result = generator.send(:calculate_projectile_collision, 0.1, 0.9, 50)
      expect(result).to be > 0
    end

    it 'correctly handles falling object collision problems' do
      result = generator.send(:calculate_falling_object_collision, nil, nil, 2, 0.8)
      expect(result).to be_within(0.01).of(1.28)
    end
  end

  describe '#build_collision_problem' do
    it 'builds a question hash with proper structure' do
      question_text = 'A bullet of mass 0.01 kg moving at 400 m/s strikes a block.'
      result = generator.send(:build_collision_problem, question_text, 0.01, 400, 100, 5)

      expect(result).to be_a(Hash)
      expect(result[:type]).to eq('momentum & collisions')
      expect(result[:question]).to eq(question_text)
      expect(result[:input_fields]).to be_an(Array)
      expect(result[:parameters]).to be_a(Hash)
    end

    it 'adds debug info in development environment' do
      allow(Rails.env).to receive(:development?).and_return(true)
      question_text = 'A bullet of mass 0.01 kg moving at 400 m/s strikes a block.'
      result = generator.send(:build_collision_problem, question_text, 0.01, 400, 100, 5)

      expect(result[:debug_info]).to be_a(Hash)
      expect(result[:debug_info][:generator]).to eq('CollisionProblemGenerator')
    end

    it 'does not add debug info in non-development environment' do
      allow(Rails.env).to receive(:development?).and_return(false)
      question_text = 'A bullet of mass 0.01 kg moving at 400 m/s strikes a block.'
      result = generator.send(:build_collision_problem, question_text, 0.01, 400, 100, 5)

      expect(result[:debug_info]).to be_nil
    end
  end

  describe '#calculate_answer' do
    it 'uses the bullet block handler for bullet problems' do
      question_text = 'A bullet moving at 400 m/s strikes a block.'
      allow(generator).to receive(:calculate_bullet_block_collision)
      generator.send(:calculate_answer, question_text, 1, 2, 3, 4)
      expect(generator).to have_received(:calculate_bullet_block_collision).with(1, 2, 3, 4)
    end

    it 'uses the hydrogen atom handler for hydrogen atom problems' do
      question_text = 'An alpha particle undergoes an elastic collision with an initially stationary hydrogen atom.'
      allow(generator).to receive(:calculate_hydrogen_atom_collision)
      generator.send(:calculate_answer, question_text, 4)
      expect(generator).to have_received(:calculate_hydrogen_atom_collision).with(4)
    end

    it 'uses the soccer ball handler for soccer ball problems' do
      question_text = 'A soccer ball with mass 0.5 kg is dropped.'
      allow(generator).to receive(:calculate_soccer_ball_collision)
      generator.send(:calculate_answer, question_text, 0.5, 0.3, 2)
      expect(generator).to have_received(:calculate_soccer_ball_collision).with(0.5, 0.3, 2)
    end

    it 'uses the car collision handler for car problems' do
      question_text = 'Two cars stick together after a collision.'
      allow(generator).to receive(:calculate_car_collision)
      generator.send(:calculate_answer, question_text, 1500, 20, 1200, -15)
      expect(generator).to have_received(:calculate_car_collision).with(1500, 20, 1200, -15)
    end

    it 'uses the pool ball handler for pool ball problems' do
      question_text = 'A pool ball of mass 0.2 kg strikes another ball.'
      allow(generator).to receive(:calculate_pool_ball_collision)
      generator.send(:calculate_answer, question_text, 0.2, 5, 30)
      expect(generator).to have_received(:calculate_pool_ball_collision).with(0.2, 5, 30)
    end

    it 'uses the pendulum handler for pendulum problems' do
      question_text = 'A pendulum bob is released from a height.'
      allow(generator).to receive(:calculate_pendulum_collision)
      generator.send(:calculate_answer, question_text, 0.1, 0.2, 20)
      expect(generator).to have_received(:calculate_pendulum_collision).with(0.1, 0.2, 20)
    end

    it 'uses the puck handler for puck problems' do
      question_text = 'A puck on a frictionless horizontal surface collides with another puck.'
      allow(generator).to receive(:calculate_puck_collision)
      generator.send(:calculate_answer, question_text, 0.3, 10, 0.3)
      expect(generator).to have_received(:calculate_puck_collision).with(0.3, 10, 0.3)
    end

    it 'uses the projectile handler for projectile problems' do
      question_text = 'A projectile traveling horizontally strikes a target.'
      allow(generator).to receive(:calculate_projectile_collision)
      generator.send(:calculate_answer, question_text, 0.1, 0.9, 50)
      expect(generator).to have_received(:calculate_projectile_collision).with(0.1, 0.9, 50)
    end

    it 'uses the falling object handler for falling object problems' do
      question_text = 'A ball is dropped onto a floor.'
      allow(generator).to receive(:calculate_falling_object_collision)
      generator.send(:calculate_answer, question_text, 0.1, 0.2, 2, 0.8)
      expect(generator).to have_received(:calculate_falling_object_collision).with(0.1, 0.2, 2, 0.8)
    end

    it 'returns default value when no handler matches' do
      question_text = "This doesn't match any pattern."
      result = generator.send(:calculate_answer, question_text, 1, 2, 3)
      expect(result).to eq(0.0)
    end
  end

  describe '#format_parameters' do
    it 'converts args array to a hash with descriptive keys' do
      result = generator.send(:format_parameters, 1, 'test', 3.5)
      expect(result).to eq({
                             'param_1' => 1,
                             'param_2' => 'test',
                             'param_3' => 3.5
                           })
    end
  end

  describe 'full problem generation flow' do
    let(:mocked_result) do
      {
        type: 'momentum & collisions',
        question: 'Test question',
        answer: 5.0
      }
    end

    before do
      allow(generator).to receive_messages(
        generator_list: [:generate_bullet_block_question],
        generate_bullet_block_question: mocked_result
      )
    end

    it 'returns a generated question with correct type' do
      result = generator.generate_questions.first
      expect(result[:type]).to eq('momentum & collisions')
    end

    it 'returns a generated question with correct content' do
      result = generator.generate_questions.first
      expect(result[:question]).to eq('Test question')
      expect(result[:answer]).to eq(5.0)
    end
  end

  describe '#generator_list' do
    it 'returns an array of available generator method symbols' do
      result = generator.send(:generator_list)
      expect(result).to be_an(Array)
      expect(result).to include(:generate_bullet_block_question)
      expect(result).to include(:generate_car_collision_question)
      expect(result).to include(:generate_pool_ball_question)
    end
  end

  describe '#default_input_field' do
    it 'returns an array with default input field configuration' do
      result = generator.send(:default_input_field)
      expect(result).to be_an(Array)
      expect(result.first).to include(type: 'numeric', label: 'Answer', key: 'answer')
    end
  end

  describe '#rounding_instructions' do
    it 'returns instructions about rounding' do
      expect(generator.send(:rounding_instructions)).to include('Round your answer')
    end
  end
end
