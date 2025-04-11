class TeacherDashboardController < ApplicationController
  before_action :require_teacher
  before_action :load_semesters, only: %i[index manage_students student_history_dashboard]

  def require_teacher
    return if session[:user_type] == 'teacher' && current_teacher

    redirect_to login_path
    nil
  end

  def index
    @students = current_teacher.students
    apply_semester_filter
  end

  def manage_students
    @students = current_teacher.students
    apply_semester_filter
  end

  def student_history_dashboard
    @all_students = current_teacher.students # All students for class stats
    @students = @all_students # Filtered students for display

    apply_semester_filter

    if params[:search].present?
      search_term = "%#{params[:search].downcase}%"
      @students = @students.where('LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ? OR LOWER(email) LIKE ?',
                                  search_term, search_term, search_term)
    end

    @category_summaries = build_category_summaries(@students) # Use filtered students
    class_performance(@students) # Use filtered students
  end

  def student_history
    # Verify the current user is a teacher
    @teacher = Teacher.find_by(id: session[:user_id])

    unless @teacher
      redirect_to login_path, alert: t('history.login_required_teacher')
      return
    end

    # Get the student email from either params[:student_email] as a URL segment or query parameter
    student_email = params[:student_email]

    # Debug information
    Rails.logger.debug { "Student History: Looking for student with email #{student_email.inspect}" }
    Rails.logger.debug { "Params: #{params.inspect}" }

    if student_email.blank?
      redirect_to teacher_dashboard_path, alert: 'Student email is required'
      return
    end

    @student = Student.find_by(email: student_email)
    Rails.logger.debug { "Student found: #{@student&.id}" }

    unless @student
      redirect_to teacher_dashboard_path, alert: t('teacher.student_not_found')
      return
    end

    # Fetch all answers for this student using email for consistency
    @completed_questions = Answer.where(student_email: @student.email)
                                 .order(created_at: :desc)

    # Calculate statistics
    @attempted = @completed_questions.count
    @correct = @completed_questions.where(correctness: true).count
    @incorrect = @attempted - @correct
    @percentage_correct = @attempted.positive? ? ((@correct.to_f / @attempted) * 100).round(2) : 0

    # Render the view template
    render 'teacher_dashboard/student_history'
  end

  def delete_semester_students
    semester_id = params[:semester_id]

    if semester_id.present?
      semester = Semester.find_by(id: semester_id)

      if semester
        students_count = current_teacher.students.by_semester(semester_id).count
        current_teacher.students.by_semester(semester_id).destroy_all

        redirect_to manage_students_path, notice: t('.success',
                                                    count: students_count,
                                                    semester: semester.name)
      else
        redirect_to manage_students_path, alert: t('.semester_not_found')
      end
    else
      redirect_to manage_students_path, alert: t('.no_semester_selected')
    end
  end

  private

  def current_teacher
    @current_teacher ||= Teacher.find_by(id: session[:user_id])
  end

  def load_semesters
    @semesters = Semester.order(active: :desc, name: :asc)
    @current_semester_id = params[:semester_id]
  end

  def apply_semester_filter
    @students = @students.by_semester(@current_semester_id) if @current_semester_id.present?
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
