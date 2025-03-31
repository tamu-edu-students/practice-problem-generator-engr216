class HistoryController < ApplicationController
  def show
    # Get the current student
    @student = Student.find_by(id: session[:user_id])

    # Redirect to login if no student is found
    unless @student
      redirect_to login_path, alert: 'Please log in to view your history.'
      return
    end

    # Fetch all answers for this student
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
      redirect_to login_path, alert: 'You must be logged in as a teacher to view student history.'
      return
    end

    # Get the requested student by ID or email parameter
    student_id = params[:student_id]
    student_email = params[:student_email]

    if student_id
      @student = Student.find_by(id: student_id)
    elsif student_email
      @student = Student.find_by(email: student_email)
    end

    unless @student
      redirect_to teacher_dashboard_path, alert: 'Student not found.'
      return
    end

    # Fetch all answers for this student
    @completed_questions = Answer.where(student_email: @student.email)
                                 .order(created_at: :desc)

    # Calculate statistics
    @attempted = @completed_questions.count
    @correct = @completed_questions.where(correctness: true).count
    @incorrect = @attempted - @correct
    @percentage_correct = @attempted.positive? ? ((@correct.to_f / @attempted) * 100).round(2) : 0

    render :show # Reuse the same view template as student history
  end
end
