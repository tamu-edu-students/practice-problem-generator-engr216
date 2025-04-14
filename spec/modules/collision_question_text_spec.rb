require 'rails_helper'

# Create a test class that includes the module to allow testing
class TestQuestionText
  include CollisionQuestionText
end

RSpec.describe CollisionQuestionText, type: :module do
  subject(:generator) { TestQuestionText.new }

  describe 'question text generation methods' do
    describe '#bullet_block_question_text' do
      it 'generates properly formatted question text' do
        question = generator.bullet_block_question_text(20, 150, 75, 250)

        expect(question).to include('20 g bullet')
        expect(question).to include('moving at 150 m/s')
        expect(question).to include('250 g wooden block')
        expect(question).to include('reduced to 75 m/s')
        expect(question).to include('What is the resulting speed of the block?')
      end
    end

    describe '#electron_collision_question_text' do
      it 'generates properly formatted question text' do
        question = generator.electron_collision_question_text(1836)

        expect(question).to include('electron undergoes')
        expect(question).to include('elastic collision')
        expect(question).to include('hydrogen atom')
        expect(question).to include('1836 times the mass of the electron')
      end
    end

    describe '#ball_drop_question_text' do
      it 'generates properly formatted question text' do
        question = generator.ball_drop_question_text(5, 10, 20)

        expect(question).to include('soccer ball with mass 5 kg')
        expect(question).to include('yoga ball with mass 10 kg')
        expect(question).to include('height of 20 m')
        expect(question).to include('How high does the soccer ball bounce')
      end
    end

    describe '#car_collision_question_text' do
      it 'generates properly formatted question text' do
        question = generator.car_collision_question_text(1500, 15, 1800, 12)

        expect(question).to include('1500 kg car traveling at 15 m/s')
        expect(question).to include('collides with a 1800 kg car')
        expect(question).to include('cars stick together')
        expect(question).to include('What is the velocity of the combined cars')
      end
    end

    describe '#pool_ball_question_text' do
      it 'generates properly formatted question text' do
        question = generator.pool_ball_question_text(150, 15, 30)

        expect(question).to include('pool ball of mass 150 g')
        expect(question).to include('speed of 15 m/s')
        expect(question).to include('angle of 30°')
        expect(question).to include('what is the speed of the target ball')
      end
    end

    describe '#pendulum_collision_question_text' do
      it 'generates properly formatted question text' do
        question = generator.pendulum_collision_question_text(150, 200, 30)

        expect(question).to include('150 g pendulum bob')
        expect(question).to include('height of 30 cm')
        expect(question).to include('200 g pendulum bob')
        expect(question).to include('What is the maximum height reached')
      end
    end

    describe '#puck_collision_question_text' do
      it 'generates properly formatted question text' do
        question = generator.puck_collision_question_text(2, 10, 3)

        expect(question).to include('frictionless horizontal surface')
        expect(question).to include('2 kg puck')
        expect(question).to include('10 m/s')
        expect(question).to include('stationary 3 kg puck')
      end
    end

    describe '#projectile_collision_question_text' do
      it 'generates properly formatted question text' do
        question = generator.projectile_collision_question_text(50, 200, 15)

        expect(question).to include('50 g projectile')
        expect(question).to include('15 m/s')
        expect(question).to include('200 g target')
        expect(question).to include('maximum height')
      end
    end

    describe '#falling_object_question_text' do
      it 'generates properly formatted question text' do
        question = generator.falling_object_question_text(5, 8, 15, 0.6)

        expect(question).to include('5 kg object is dropped')
        expect(question).to include('8 kg object')
        expect(question).to include('15 m')
        expect(question).to include('0.6')
      end
    end
  end
end
