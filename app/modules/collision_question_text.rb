# Module for collision physics question text formatting
module CollisionQuestionText
  def bullet_block_question_text(bullet_mass, bullet_initial_speed, bullet_final_speed, block_mass)
    "A #{bullet_mass} g bullet moving at #{bullet_initial_speed} m/s strikes a #{block_mass} g wooden block at rest
     on a frictionless surface. " \
      "The bullet emerges, traveling in the same direction with its speed reduced to #{bullet_final_speed} m/s. " \
      'What is the resulting speed of the block?'
  end

  def electron_collision_question_text(mass_ratio)
    'An electron undergoes a one-dimensional elastic collision with an initially stationary hydrogen atom. ' \
      "What percentage of the electron's initial kinetic energy is transferred to kinetic energy
       of the hydrogen atom? " \
      "The mass of the hydrogen atom is #{mass_ratio} times the mass of the electron."
  end

  def ball_drop_question_text(ball1_mass, ball2_mass, drop_height)
    "A soccer ball with mass #{ball1_mass} kg is held above a yoga ball with mass #{ball2_mass} kg " \
      "and dropped together from a height of #{drop_height} m. " \
      'The two balls hit the floor and the yoga ball transfers all of its momentum to the soccer ball. ' \
      'How high does the soccer ball bounce into the air?'
  end

  def car_collision_question_text(car1_mass, car1_speed, car2_mass, car2_speed)
    "A #{car1_mass} kg car traveling at #{car1_speed} m/s collides with a #{car2_mass} kg car moving at #{car2_speed}
     m/s in the same direction. " \
      'After the collision, the cars stick together. ' \
      'What is the velocity of the combined cars immediately after the collision?'
  end

  def pool_ball_question_text(ball_mass, initial_speed, angle)
    "A pool ball of mass #{ball_mass} g moving with a speed of #{initial_speed} m/s collides elastically with an
     identical stationary ball. " \
      "If the incoming ball deflects at an angle of #{angle}° from its original direction, " \
      'what is the speed of the target ball after the collision?'
  end

  def pendulum_collision_question_text(pendulum1_mass, pendulum2_mass, pendulum1_height)
    "A #{pendulum1_mass} g pendulum bob is released from a height of #{pendulum1_height} cm and swings down to collide
     elastically with a stationary #{pendulum2_mass} g pendulum bob. " \
      'What is the maximum height reached by the second pendulum after the collision?'
  end

  def puck_collision_question_text(puck1_mass, puck1_speed, puck2_mass)
    "On a frictionless horizontal surface, a #{puck1_mass} kg puck moving at
     #{puck1_speed} m/s makes a perfectly elastic
     collision with a stationary #{puck2_mass} kg puck. " \
      'What are the velocities of both pucks after the collision?'
  end

  def projectile_collision_question_text(projectile_mass, target_mass, projectile_speed)
    "A #{projectile_mass} g projectile traveling horizontally at #{projectile_speed} m/s strikes and becomes embedded
   in a #{target_mass} g target " \
      'suspended by a string of length 1.2 m. ' \
      'What is the maximum height that the combined object reaches after the collision?'
  end

  def falling_object_question_text(object1_mass, object2_mass, initial_height, restitution)
    "A #{object1_mass} kg object is dropped onto a #{object2_mass} kg object at rest on the ground from a height
     of #{initial_height} m. " \
      "If the coefficient of restitution between the objects is #{restitution}, " \
      'how high does the upper object bounce after the collision?'
  end
end
