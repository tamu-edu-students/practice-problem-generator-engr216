module TeacherDashboard
  class StudentStatisticsController < ApplicationController
    before_action :require_teacher_login

    def index
      @students = Student.where(teacher_id: current_teacher.id)
      Rails.logger.debug { "Index - @students: #{@students.inspect}" }
    end

    def show
      @student = Student.find(params[:id])
      # Use StudentCategoryStatistic instead of Answer
      @stats = StudentCategoryStatistic.where(student_id: @student.id)
      total_attempts = @stats.sum(:attempts)
      correct_attempts = @stats.sum(:correct_attempts)
      incorrect_attempts = total_attempts - correct_attempts
      @summary = "Total problems: #{total_attempts}, Correct: #{correct_attempts}, Incorrect: #{incorrect_attempts}"
    end

    private

    def require_teacher_login
      redirect_to root_path unless session[:user_type] == 'teacher'
    end

    def current_teacher
      @current_teacher ||= Teacher.find(session[:user_id]) if session[:user_type] == 'teacher'
    end
  end
end
