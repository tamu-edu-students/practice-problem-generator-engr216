module TeacherDashboard
  class StudentStatisticsController < ApplicationController
    before_action :require_teacher_login

    def index
      @students = Student.where(teacher_id: current_teacher.id)
      Rails.logger.debug "Index - @students: #{@students.inspect}"
    end

    def show
      @student = Student.find(params[:id])
      # Replace @answers with a summary string
      correct_count = Answer.where(student_email: @student.email, correctness: true).count
      total_count = Answer.where(student_email: @student.email).count
      @problem_summary = "Total problems: #{total_count}, Correct: #{correct_count}, Incorrect: #{total_count - correct_count}"
      Rails.logger.debug "Show - @problem_summary: #{@problem_summary}"
    end

    private

    def require_teacher_login
      redirect_to root_path unless session[:user_type] == "teacher"
    end

    def current_teacher
      @current_teacher ||= Teacher.find(session[:user_id]) if session[:user_type] == "teacher"
    end
  end
end