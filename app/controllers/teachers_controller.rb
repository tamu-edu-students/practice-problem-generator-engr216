class TeachersController < ApplicationController
  def show
    @current_teacher = Teacher.find(params[:id])
  end
    # GET /teachers
  def index
    @teachers = Teacher.all
  end
end
