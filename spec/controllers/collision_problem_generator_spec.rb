require 'rails_helper'

RSpec.describe CollisionProblemGenerator do
  let(:generator) { described_class.new('collision') }

  describe 'physics calculations' do
    describe '#calculate_momentum' do
      it 'correctly calculates momentum' do
        expect(generator.send(:calculate_momentum, 5, 10)).to eq(50)
        expect(generator.send(:calculate_momentum, 2.5, -4)).to eq(-10)
      end
    end

    describe '#calculate_kinetic_energy' do
      it 'correctly calculates kinetic energy' do
        expect(generator.send(:calculate_kinetic_energy, 2, 3)).to eq(9)
        expect(generator.send(:calculate_kinetic_energy, 4, 2)).to eq(8)
      end
    end

    describe '#calculate_final_velocity_elastic_obj1' do
      it 'correctly calculates velocity for equal masses' do
        # For equal masses, objects should exchange velocities
        expect(generator.send(:calculate_final_velocity_elastic_obj1, 1, 5, 1, 0)).to eq(0)
        expect(generator.send(:calculate_final_velocity_elastic_obj1, 2, 3, 2, -1)).to eq(-1)
      end

      it 'correctly calculates velocity for different masses' do
        # Test with specific values that have known outcomes
        expect(generator.send(:calculate_final_velocity_elastic_obj1, 2, 4, 1, 0)).to be_within(0.01).of(4.0 / 3)
        expect(generator.send(:calculate_final_velocity_elastic_obj1, 1, 2, 3, 0)).to be_within(0.01).of(-4.0 / 4)
      end
    end

    describe '#calculate_final_velocity_elastic_obj2' do
      it 'correctly calculates velocity for equal masses' do
        # For equal masses, objects should exchange velocities
        expect(generator.send(:calculate_final_velocity_elastic_obj2, 1, 5, 1, 0)).to eq(5)
        expect(generator.send(:calculate_final_velocity_elastic_obj2, 2, 3, 2, -1)).to eq(3)
      end

      it 'correctly calculates velocity for different masses' do
        # Test with specific values that have known outcomes
        expect(generator.send(:calculate_final_velocity_elastic_obj2, 2, 4, 1, 0)).to be_within(0.01).of(16.0 / 3)
        expect(generator.send(:calculate_final_velocity_elastic_obj2, 1, 2, 3, 0)).to be_within(0.01).of(1.0)
      end
    end

    describe '#calculate_final_velocity_perfectly_inelastic' do
      it 'correctly calculates velocity after perfectly inelastic collision' do
        expect(generator.send(:calculate_final_velocity_perfectly_inelastic, 2, 3, 2, -1)).to eq(1)
        expect(generator.send(:calculate_final_velocity_perfectly_inelastic, 1, 5, 4, 0)).to eq(1)
      end
    end

    describe '#calculate_final_velocity_inelastic' do
      it 'correctly calculates velocities with coefficient of restitution' do
        # With e=1 (elastic), should match elastic collision results
        v1, v2 = generator.send(:calculate_final_velocity_inelastic, 1, 2, 1, 0, 1.0)
        expect(v1).to be_within(0.01).of(0)
        expect(v2).to be_within(0.01).of(2)

        # With e=0.5 (partially inelastic)
        v1, v2 = generator.send(:calculate_final_velocity_inelastic, 1, 4, 1, 0, 0.5)
        expect(v1).to be_within(0.01).of(1)
        expect(v2).to be_within(0.01).of(3)
      end
    end
  end

  describe 'answer calculations' do
    it 'correctly calculates electron collision percentage' do
      # Hydrogen atom (proton) mass is approximately 1836 times electron mass
      answer = generator.send(:calculate_answer,
                              'elastic collision with an initially stationary hydrogen atom',
                              1 / 1836.0)
      expect(answer).to be_within(0.01).of(0.22)
    end

    it 'correctly calculates car collision final velocity' do
      answer = generator.send(:calculate_answer,
                              'cars stick together',
                              1500, 20, 2500, -15)
      expect(answer).to be_within(0.01).of(-1.875)
    end

    it 'correctly calculates puck collision velocities' do
      answer = generator.send(:calculate_answer,
                              'frictionless horizontal surface',
                              2, 5, 3)
      expect(answer[:puck1]).to be_within(0.01).of(-1)
      expect(answer[:puck2]).to be_within(0.01).of(4)
    end
  end
end
