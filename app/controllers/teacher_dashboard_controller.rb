class TeacherDashboardController < ApplicationController
  before_action :require_teacher

  def require_teacher
    return if session[:user_type] == 'teacher'

    redirect_to login_path
  end

  def index
    @students = Student.all
  end

  def manage_students
    @students = Student.all
  end
end
