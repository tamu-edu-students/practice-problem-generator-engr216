class TeacherDashboardController < ApplicationController
  before_action :require_teacher
  def retrieve_students
    @students = Student.all
  end

  def require_teacher
    unless session[:user_type] == 'teacher'
      flash[:alert] = "You must be logged in as a teacher to access that page."
      redirect_to login_path
    end
  end
end
