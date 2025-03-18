class TeacherDashboardController < ApplicationController
  before_action :require_teacher

  def require_teacher
    return if session[:user_type] == 'teacher' && current_teacher

    redirect_to login_path
    nil
  end

  def index
    @students = current_teacher.students
  end

  def manage_students
    @students = Student.all
    # @students = current_teacher.students # <-- is the correct implementation if we want to limit management to respective students. 
  end

  def student_history_dashboard
    @all_students = current_teacher.students # All students for class stats
    @students = @all_students # Filtered students for display
    if params[:search].present?
      search_term = "%#{params[:search].downcase}%"
      @students = @students.where('LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ? OR CAST(uin AS TEXT) LIKE ?',
                                  search_term, search_term, search_term)
    end
    @category_summaries = build_category_summaries(@all_students) # Use all students
    class_performance(@all_students) # Use all students
  end

  def student_history
    @student = current_teacher.students.find_by!(uin: params[:uin])
    @completed_questions = Answer.where(student_email: @student.email).joins(:question)
    set_student_stats
  end

  private

  def current_teacher
    @current_teacher ||= Teacher.find_by(id: session[:user_id])
  end

  def build_category_summaries(students)
    Answer.where(student_email: students.pluck(:email))
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

  def class_performance(students)
    answers = Answer.where(student_email: students.pluck(:email))
    @total_completed = {
      attempted: answers.count,
      correct: answers.where(correctness: true).count,
      incorrect: answers.where(correctness: false).count,
      percentage: answers.count.zero? ? 0 : (answers.where(correctness: true).count.to_f / answers.count * 100).round(1)
    }
  end

  def set_student_stats
    @attempted = @completed_questions.count
    @correct = @completed_questions.where(correctness: true).count
    @incorrect = @completed_questions.where(correctness: false).count
    @percentage_correct = @attempted.zero? ? 'N/A' : format('%.1f%%', (@correct.to_f / @attempted * 100))
  end
end
