class TeachersController < ApplicationController
  # GET /teachers
  def index
    @teachers = Teacher.all
  end

  # before_action :authorize_teacher
  def show
    @current_teacher = Teacher.find(params[:id])
  end
end
