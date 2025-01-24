class SessionsController < ApplicationController
  # GET /logout
  def logout
    reset_session
    redirect_to root_path, notice: 'You are logged out.'
  end

  # GET /auth/google_oauth2/callback
  def omniauth
    auth = request.env['omniauth.auth']
    user_type = request.env['omniauth.params']['state'] # Retrieve the state parameter

    case user_type
    when "teacher"
      @teacher = Teacher.find_or_create_by(uid: auth['uid'], provider: auth['provider']) do |u|
        u.email = auth['info']['email']
        names = auth['info']['name'].split
        u.first_name = names[0]
        u.last_name = names[1..].join(' ')
      end

      if @teacher.valid?
        session[:teacher_id] = @teacher.id
        redirect_to teachers_path, notice: 'Logged in as a teacher.'
      else
        redirect_to root_path, alert: 'Teacher login failed.'
      end

    when "student"
      @student = Student.find_or_create_by(uid: auth['uid'], provider: auth['provider']) do |u|
        names = auth['info']['name'].split
        u.first_name = names[0]
        u.last_name = names[1..].join(' ')
      end

      if @student.valid?
        session[:student_id] = @student.id
        redirect_to students_path, notice: 'Logged in as a student.'
      else
        redirect_to root_path, alert: 'Student login failed.'
      end

    else
      redirect_to root_path, alert: 'Invalid user type.'
    end
  end
end
