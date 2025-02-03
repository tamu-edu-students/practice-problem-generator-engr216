class SessionsController < ApplicationController
  # GET /logout
  # def logout
  #  reset_session
  #  session[:user_id] = nil
  #  session[:user_type] = nil
  # redirect_to root_path, notice: 'You are logged out.'
  # end

  # GET /auth/google_oauth2/callback
  def omniauth
    auth = request.env['omniauth.auth']

    if params[:state] == 'teacher'
      # @teacher = Teacher.find_or_create_by(uid: auth['uid'], provider: auth['provider']) do |u|
      #   u.email = auth['info']['email']
      #   names = auth['info']['name'].split
      #   u.first_name = names[0]
      #   u.last_name = names[1..].join(' ')
      # end
      teacher = Teacher.find_by(email: auth.info.email)
      if (teacher) 
        session[:user_type] = 'teacher' 
        redirect_to teacher_dashboard_path, notice: t('teacher.logged_in')
      else
        redirect_to root_path, alert: 'Login failed.'
      end
    elsif params[:state] == 'student'
      # @student = Student.find_or_create_by(uid: auth['uid'], provider: auth['provider']) do |u|
      #   names = auth['info']['name'].split
      #   u.first_name = names[0]
      #   u.last_name = names[1..].join(' ')
      # end

      # if @student.valid?
      #   session[:user_id] = @student.id
      #   session[:user_type] = 'student'
      redirect_to practice_problems_path, notice: t('student.logged_in')
      # else
      #   redirect_to root_path, alert: 'Login failed.'
      # end
    else
      redirect_to root_path, alert: t('sessions.invalid_user_type')
    end
  end

  def auth_failure
    # Handle OAuth failure, e.g., log the error or redirect
    flash[:alert] = "Authentication failed: #{params[:message].humanize}"
    redirect_to root_path
  end
end
