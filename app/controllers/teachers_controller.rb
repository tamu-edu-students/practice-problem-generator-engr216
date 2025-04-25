class TeachersController < ApplicationController
  before_action :require_teacher

  def new
    @teacher = Teacher.new
  end

  def create
    @teacher = Teacher.new(teacher_params)

    if @teacher.save
      redirect_to teacher_dashboard_path, notice: t('teacher.created')
    else
      flash.now[:alert] = t('teacher.creation_error')
      render :new, status: :unprocessable_entity
    end
  end

  private

  def teacher_params
    params.expect(teacher: %i[name email])
  end

  def require_teacher
    return if session[:user_type] == 'teacher' && current_teacher

    redirect_to login_path
    nil
  end

  def current_teacher
    @current_teacher ||= Teacher.find_by(id: session[:user_id])
  end
end
