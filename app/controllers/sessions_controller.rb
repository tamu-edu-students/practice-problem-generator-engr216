class SessionsController < ApplicationController
  def logout
   reset_session
   session[:user_id] = nil
   session[:user_type] = nil
  redirect_to root_path, notice: 'You are logged out.'
  end

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
    # Handle OAuth failure, e.g., log the error or redirect
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

    return root_path unless valid_email_domain?(email)

    student = find_or_create_student(auth)
    return root_path unless student

    student_session_set(student)
    redirect_to practice_problems_path, notice: t('student.logged_in')
  end

  private

  def valid_email_domain?(email)
    email.end_with?('tamu.edu')
  end

  def redirect_invalid_domain
    redirect_to root_path, alert: t('sessions.invalid_domain')
  end

  def find_or_create_student(auth)
    email = auth.info.email
    Rails.logger.debug { "[OAuth] Attempting to find or create student with email: #{email}" }
    Rails.logger.debug { "[OAuth] Auth Info: #{auth.info.to_h}" }

    student = Student.find_or_create_by(email: email) do |s|
      s.first_name = auth.info.first_name
      s.last_name = auth.info.last_name
      s.uin = 100_000_000
    end

    if student.persisted?
      Rails.logger.debug { "[OAuth] Student persisted successfully: #{student.inspect}" }
    else
      Rails.logger.error "[OAuth] Student failed to persist: #{student.errors.full_messages.join(', ')}"
    end

    student
  end

  def redirect_login_failed
    redirect_to root_path, alert: t('sessions.login_failed')
  end

  def student_session_set(student)
    session[:user_id] = student.id
    session[:user_type] = 'student'
  end
end
