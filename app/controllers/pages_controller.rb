class PagesController < ApplicationController
  def login; end

  def teacher_oauth
    redirect_to '/auth/google_oauth2?state=teacher'
  end

  def student_oauth
    redirect_to '/auth/google_oauth2?state=student'
  end

  def student_home
    redirect_to practice_problems_path
  end

  def teacher_home
    redirect_to teacher_dashboard_path
  end

  def problem_type1
    redirect_to practice_problems_path
  end
end
