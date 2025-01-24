class ApplicationController < ActionController::Base
  helper_method :current_user, :current_user_type

  def current_user
    if session[:user_type] == 'teacher'
      @current_user ||= Teacher.find_by(id: session[:user_id])
    elsif session[:user_type] == 'student'
      @current_user ||= Student.find_by(id: session[:user_id])
    end
  end

  def current_user_type
    session[:user_type]
  end

  def authorize_teacher
    unless current_user_type == 'teacher'
      redirect_to root_path, alert: 'Access denied.'
    end
  end

  def authorize_student
    unless current_user_type == 'student'
      redirect_to root_path, alert: 'Access denied.'
    end
  end
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
end
