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

  def student_statistics
    # If a student is selected, load that student’s data.
    @selected_student = Student.find(params[:student_id]) if params[:student_id].present?
    @students = Student.all
    @categories = Category.all
  end

end
