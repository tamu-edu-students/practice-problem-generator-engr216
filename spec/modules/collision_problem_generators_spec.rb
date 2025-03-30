require 'rails_helper'

RSpec.describe CollisionProblemGenerators do
  let(:test_class) do
    Class.new do
      include CollisionProblemGenerators
      include CollisionQuestionText

      def build_collision_problem(question, *args)
        {
          question: question,
          parameters: args
        }
      end
    end
  end

  let(:generator) { test_class.new }

  describe 'problem generators' do
    describe '#generate_bullet_block_question' do
      it 'creates a bullet block problem' do
        problem = generator.generate_bullet_block_question
        expect(problem[:question]).to include('bullet moving at')
        expect(problem[:parameters].length).to eq(4)
      end
    end

    describe '#generate_electron_collision_question' do
      it 'creates an electron collision problem' do
        problem = generator.generate_electron_collision_question
        expect(problem[:question]).to include('electron undergoes')
        expect(problem[:parameters].length).to eq(1)
      end
    end

    describe '#generate_ball_drop_question' do
      it 'creates a ball drop problem' do
        problem = generator.generate_ball_drop_question
        expect(problem[:question]).to include('soccer ball with mass')
        expect(problem[:parameters].length).to eq(3)
      end
    end

    describe '#generate_car_collision_question' do
      it 'creates a car collision problem' do
        problem = generator.generate_car_collision_question
        expect(problem[:question]).to include('cars stick together')
        expect(problem[:parameters].length).to eq(4)
      end
    end

    describe '#generate_pool_ball_question' do
      it 'creates a pool ball problem' do
        problem = generator.generate_pool_ball_question
        expect(problem[:question]).to include('pool ball of mass')
        expect(problem[:parameters].length).to eq(3)
      end
    end

    describe '#generate_pendulum_collision_question' do
      it 'creates a pendulum collision problem' do
        problem = generator.generate_pendulum_collision_question
        expect(problem[:question]).to include('pendulum bob is released')
        expect(problem[:parameters].length).to eq(3)
      end
    end

    describe '#generate_puck_collision_question' do
      it 'creates a puck collision problem' do
        problem = generator.generate_puck_collision_question
        expect(problem[:question]).to include('frictionless horizontal surface')
        expect(problem[:parameters].length).to eq(3)
      end
    end

    describe '#generate_projectile_collision_question' do
      it 'creates a projectile collision problem' do
        problem = generator.generate_projectile_collision_question
        expect(problem[:question]).to include('projectile traveling horizontally')
        expect(problem[:parameters].length).to eq(3)
      end
    end

    describe '#generate_falling_object_question' do
      it 'creates a falling object problem' do
        problem = generator.generate_falling_object_question
        expect(problem[:question]).to include('dropped onto a')
        expect(problem[:parameters].length).to eq(4)
      end
    end
  end
end
