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

  def student_history_dashboard
    @students = Student.all
  end

  def student_history
    @student = Student.find_by!(uin: params[:uin])
    @completed_questions = Answer.where(student_email: @student.email).joins(:question)
    set_student_stats
  end

  # used by student_history page
  def set_student_stats
    @attempted = @completed_questions.count
    @correct = @completed_questions.where(correctness: true).count
    @incorrect = @completed_questions.where(correctness: false).count
    @percentage_correct = @attempted.zero? ? 'N/A' : format('%.1f%%', (@correct.to_f / @attempted * 100))
  end
end
