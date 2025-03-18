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
    @category_summaries = build_category_summaries
  end

  def build_category_summaries
    Answer.where(student_email: @students.pluck(:email))
          .group(:category)
          .select('category,
        COUNT(*) AS attempted,
        SUM(CASE WHEN correctness THEN 1 ELSE 0 END) AS correct,
        SUM(CASE WHEN correctness THEN 0 ELSE 1 END) AS incorrect')
          .to_h { |cat| format_category_summary(cat) }
  end

  def format_category_summary(cat)
    percentage = cat.attempted.zero? ? 0 : (cat.correct.to_f / cat.attempted * 100).round(1)
    [cat.category, { attempted: cat.attempted, correct: cat.correct, incorrect: cat.incorrect, percentage: percentage }]
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
