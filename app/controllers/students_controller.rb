class StudentsController < ApplicationController
  # before_action :authorize_student
  before_action :set_student, only: %i[show edit update destroy]

  # GET /students
  def index
    @students = Student.all
  end

  # GET /students/1
  def show; end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit; end

  # POST /students
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to @student, notice: t('student.created') }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to manage_students_path, notice: t('student.updated') }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  def destroy
    @student.destroy!

    respond_to do |format|
      format.html { redirect_to students_path, status: :see_other, notice: t('student.destroyed') }
      format.json { head :no_content }
    end
  end

  # POST /update_uin
  def update_uin
    student = Student.find_by(id: session[:user_id])
    new_uin = 123_456_789 # Placeholder to disable popup
    teacher = Teacher.find_by(id: params[:teacher_id])
    semester = params[:semester]

    authenticate = ActiveModel::Type::Boolean.new.cast(params[:authenticate])

    if teacher.present? && semester.present?
      student.update(uin: new_uin, teacher: teacher, semester: semester, authenticate: authenticate)
      flash[:notice] = 'Your settings were saved. Good luck studying!'
    else
      flash[:alert] = determine_error_message(student, new_uin, teacher)
    end

    redirect_to practice_problems_path
  end

  private

  def set_student
    @student = Student.find(params[:id])
  end

  def student_params
    params.expect(student: %i[first_name last_name email uin teacher teacher_id authenticate semester])
  end

  # === Refactored helpers for update_uin ===

  def find_logged_in_student
    Student.find_by(id: session[:user_id])
  end

  def find_selected_teacher
    Teacher.find_by(id: params[:teacher_id])
  end

  def valid_update_request?(student, _new_uin, teacher)
    student.present? && teacher.present?
  end

  def determine_error_message(_student, _new_uin, teacher)
    return t('student.update_uin.not_found') if teacher.nil?

    # For all other invalid cases
    t('student.update_uin.error')
  end
end
