require 'rails_helper'

# Create a test class that includes the modules to allow testing
class TestCollisionGenerator
  include CollisionQuestionText
  include CollisionProblemGenerators

  # Add build_collision_problem method that the module expects
  def build_collision_problem(question_text, *args)
    {
      question: question_text,
      params: args
    }
  end
end

RSpec.describe CollisionProblemGenerators, type: :module do
  subject(:generator) { TestCollisionGenerator.new }

  describe 'generator methods' do
    describe '#generate_bullet_block_question' do
      it 'generates a bullet block collision problem' do
        problem = generator.generate_bullet_block_question
        expect(problem[:question]).to include('bullet moving at')
        expect(problem[:question]).to include('wooden block at rest')
      end
    end

    describe '#generate_electron_collision_question' do
      it 'generates an electron collision problem' do
        problem = generator.generate_electron_collision_question
        expect(problem[:question]).to include('electron undergoes')
        expect(problem[:question]).to include('hydrogen atom')
      end
    end

    describe '#generate_ball_drop_question' do
      it 'generates a ball drop problem' do
        problem = generator.generate_ball_drop_question
        expect(problem[:question]).to include('soccer ball with mass')
        expect(problem[:question]).to include('dropped together from a height')
      end
    end

    describe '#generate_car_collision_question' do
      it 'generates a car collision problem' do
        problem = generator.generate_car_collision_question
        expect(problem[:question]).to include('car traveling at')
        expect(problem[:question]).to include('cars stick together')
      end
    end

    describe '#generate_pool_ball_question' do
      it 'generates a pool ball collision problem' do
        problem = generator.generate_pool_ball_question
        expect(problem[:question]).to include('pool ball of mass')
        expect(problem[:question]).to include('collides elastically')
      end
    end

    describe '#generate_pendulum_collision_question' do
      it 'generates a pendulum collision problem' do
        problem = generator.generate_pendulum_collision_question
        expect(problem[:question]).to include('pendulum bob is released')
        expect(problem[:question]).to include('pendulum bob')
      end
    end

    describe '#generate_puck_collision_question' do
      it 'generates a puck collision problem' do
        problem = generator.generate_puck_collision_question
        expect(problem[:question]).to include('frictionless horizontal surface')
        expect(problem[:question]).to include('perfectly elastic')
      end
    end

    describe '#generate_projectile_collision_question' do
      it 'generates a projectile collision problem' do
        problem = generator.generate_projectile_collision_question
        expect(problem[:question]).to include('projectile traveling horizontally')
        expect(problem[:question]).to include('becomes embedded')
      end
    end

    describe '#generate_falling_object_question' do
      it 'generates a falling object collision problem' do
        problem = generator.generate_falling_object_question
        expect(problem[:question]).to include('dropped onto')
        expect(problem[:question]).to include('coefficient of restitution')
      end
    end
  end

  describe 'parameters generation' do
    it 'generates random parameters within expected ranges for bullet problem' do
      problem = generator.generate_bullet_block_question

      # Extract parameters
      bullet_mass, bullet_initial_speed, bullet_final_speed, block_mass = problem[:params]

      # Verify ranges
      expect(bullet_mass).to be_between(10, 50)
      expect(bullet_initial_speed).to be_between(100, 200)
      expect(bullet_final_speed).to be_between(50, 100)
      expect(block_mass).to be_between(100, 500)
    end

    it 'generates random parameters within expected ranges for car collision' do
      problem = generator.generate_car_collision_question

      # Extract parameters
      car1_mass, car1_speed, car2_mass, car2_speed = problem[:params]

      # Verify ranges
      expect(car1_mass).to be_between(1000, 2000)
      expect(car1_speed).to be_between(10, 20)
      expect(car2_mass).to be_between(1000, 2000)
      expect(car2_speed).to be_between(10, 20)
    end
  end
end
