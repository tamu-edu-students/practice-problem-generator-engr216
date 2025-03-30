require 'rails_helper'

RSpec.describe CollisionQuestionText do
  let(:test_class) do
    Class.new do
      include CollisionQuestionText
    end
  end

  let(:formatter) { test_class.new }

  describe 'question text formatting' do
    describe '#bullet_block_question_text' do
      it 'formats bullet block question correctly' do
        question = formatter.bullet_block_question_text(20, 150, 75, 200)
        expect(question).to include('20 g bullet')
        expect(question).to include('150 m/s')
        expect(question).to include('75 m/s')
        expect(question).to include('200 g wooden block')
      end
    end

    describe '#electron_collision_question_text' do
      it 'formats electron collision question correctly' do
        question = formatter.electron_collision_question_text(150)
        expect(question).to include('electron undergoes')
        expect(question).to include('150 times the mass')
      end
    end

    describe '#ball_drop_question_text' do
      it 'formats ball drop question correctly' do
        question = formatter.ball_drop_question_text(150, 180, 30)
        expect(question).to include('mass 150 kg')
        expect(question).to include('mass 180 kg')
        expect(question).to include('height of 30 m')
      end
    end

    describe '#car_collision_question_text' do
      it 'formats car collision question correctly' do
        question = formatter.car_collision_question_text(1500, 15, 1800, 12)
        expect(question).to include('1500 kg car')
        expect(question).to include('15 m/s')
        expect(question).to include('1800 kg car')
        expect(question).to include('12
     m/s')
      end
    end

    describe '#pool_ball_question_text' do
      it 'formats pool ball question correctly' do
        question = formatter.pool_ball_question_text(150, 15, 30)
        expect(question).to include('mass 150 g')
        expect(question).to include('15 m/s')
        expect(question).to include('30°')
      end
    end

    describe '#pendulum_collision_question_text' do
      it 'formats pendulum collision question correctly' do
        question = formatter.pendulum_collision_question_text(150, 180, 30)
        expect(question).to include('150 g pendulum')
        expect(question).to include('180 g pendulum')
        expect(question).to include('30 cm')
      end
    end

    describe '#puck_collision_question_text' do
      it 'formats puck collision question correctly' do
        question = formatter.puck_collision_question_text(150, 15, 180)
        expect(question).to include('150 kg puck')
        expect(question).to include('15 m/s')
        expect(question).to include('180 kg puck')
      end
    end

    describe '#projectile_collision_question_text' do
      it 'formats projectile collision question correctly' do
        question = formatter.projectile_collision_question_text(150, 180, 15)
        expect(question).to include('150 g projectile')
        expect(question).to include('15 m/s')
        expect(question).to include('180 g target')
      end
    end

    describe '#falling_object_question_text' do
      it 'formats falling object question correctly' do
        question = formatter.falling_object_question_text(150, 180, 30, 0.8)
        expect(question).to include('150 kg object')
        expect(question).to include('180 kg object')
        expect(question).to include('30 m')
        expect(question).to include('0.8')
      end
    end
  end
end
