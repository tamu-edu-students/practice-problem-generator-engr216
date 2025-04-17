# Module containing all confidence interval problem generators
module CollisionProblemGenerators
  def generate_bullet_block_question
    bullet_mass = rand(10..50)
    bullet_initial_speed = rand(100..200)
    bullet_final_speed = rand(50..100)
    block_mass = rand(100..500)
    question = bullet_block_question_text(bullet_mass, bullet_initial_speed, bullet_final_speed, block_mass)
    build_collision_problem(question, bullet_mass, bullet_initial_speed, bullet_final_speed, block_mass, 1)
  end

  def generate_electron_collision_question
    mass_ratio = rand(100..200)
    question = electron_collision_question_text(mass_ratio)
    build_collision_problem(question, mass_ratio, 2)
  end

  def generate_ball_drop_question
    ball1_mass = rand(100..200)
    ball2_mass = rand(100..200)
    drop_height = rand(10..50)
    question = ball_drop_question_text(ball1_mass, ball2_mass, drop_height)
    build_collision_problem(question, ball1_mass, ball2_mass, drop_height, 3)
  end

  def generate_car_collision_question
    car1_mass = rand(1000..2000)
    car1_speed = rand(10..20)
    car2_mass = rand(1000..2000)
    car2_speed = rand(10..20)
    question = car_collision_question_text(car1_mass, car1_speed, car2_mass, car2_speed)
    build_collision_problem(question, car1_mass, car1_speed, car2_mass, car2_speed, 4)
  end

  def generate_pool_ball_question
    ball_mass = rand(100..200)
    initial_speed = rand(10..20)
    angle = rand(10..90)
    question = pool_ball_question_text(ball_mass, initial_speed, angle)
    build_collision_problem(question, ball_mass, initial_speed, angle, 5)
  end

  def generate_pendulum_collision_question
    pendulum1_mass = rand(100..200)
    pendulum2_mass = rand(100..200)
    pendulum1_height = rand(10..50)
    question = pendulum_collision_question_text(pendulum1_mass, pendulum2_mass, pendulum1_height)
    build_collision_problem(question, pendulum1_mass, pendulum2_mass, pendulum1_height, 6)
  end

  def generate_puck_collision_question
    puck1_mass = rand(100..200)
    puck1_speed = rand(10..20)
    puck2_mass = rand(100..200)
    question = puck_collision_question_text(puck1_mass, puck1_speed, puck2_mass)
    build_collision_problem(question, puck1_mass, puck1_speed, puck2_mass, 7)
  end

  def generate_projectile_collision_question
    projectile_mass = rand(100..200)
    target_mass = rand(100..200)
    projectile_speed = rand(10..20)
    question = projectile_collision_question_text(projectile_mass, target_mass, projectile_speed)
    build_collision_problem(question, projectile_mass, target_mass, projectile_speed, 8)
  end

  def generate_falling_object_question
    object1_mass = rand(100..200)
    object2_mass = rand(100..200)
    initial_height = rand(10..50)
    restitution = rand(1..10) / 10.0
    question = falling_object_question_text(object1_mass, object2_mass, initial_height, restitution)
    build_collision_problem(question, object1_mass, object2_mass, initial_height, restitution, 9)
  end
end
