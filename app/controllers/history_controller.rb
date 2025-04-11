class HistoryController < ApplicationController
  def show
    # Verify the current user is a student
    @student = Student.find_by(id: session[:user_id])

    unless @student
      redirect_to login_path, alert: t('history.login_required')
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
  end

  def teacher_view
    # Verify the current user is a teacher
    @teacher = Teacher.find_by(id: session[:user_id])

    unless @teacher
      redirect_to login_path, alert: t('history.login_required_teacher')
      return
    end

    # Get the requested student by email parameter
    student_email = params[:student_email]
    @student = Student.find_by(email: student_email)

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

    render :show
  end
end
