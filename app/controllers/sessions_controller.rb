class SessionsController < ApplicationController
  def omniauth
    auth = request.env['omniauth.auth']

    case params[:state]
    when 'teacher'
      handle_teacher_login(auth)
    when 'student'
      handle_student_login(auth)
    else
      redirect_to root_path, alert: t('sessions.invalid_user_type')
    end
  end

  def auth_failure
    flash[:alert] = "Authentication failed: #{params[:message].humanize}"
    redirect_to root_path
  end

  def handle_teacher_login(auth)
    teacher = Teacher.find_by(email: auth.info.email)
    if teacher
      session[:user_id] = teacher.id
      session[:user_type] = 'teacher'
      redirect_to teacher_dashboard_path, notice: t('teacher.logged_in')
    else
      redirect_to root_path, alert: t('sessions.login_failed')
    end
  end

  def handle_student_login(auth)
    email = auth.info.email

    unless valid_email_domain?(email)
      redirect_to root_path, alert: t('sessions.invalid_domain')
      return
    end

    student = find_or_create_student(auth)
    unless student
      redirect_to root_path, alert: t('sessions.login_failed')
      return
    end

    student_session_set(student)
    redirect_to practice_problems_path, notice: t('student.logged_in')
  end

  private

  def valid_email_domain?(email)
    email.end_with?('tamu.edu')
  end

  def find_or_create_student(auth)
    Student.find_or_create_by(email: auth.info.email) do |student|
      student.first_name = auth.info.first_name
      student.last_name = auth.info.last_name
      student.uin = '123456789' # Default UIN for testing
    end
  rescue ActiveRecord::RecordInvalid
    nil # Return nil on validation failure
  end

  def student_session_set(student)
    session[:user_id] = student.id
    session[:user_type] = 'student'
  end
end