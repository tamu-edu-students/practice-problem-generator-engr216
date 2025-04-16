class StudentsController < ApplicationController
  # before_action :authorize_student
  before_action :set_student, only: %i[show edit update destroy]
  before_action :load_semesters, only: %i[new edit create update]

  # GET /students
  def index
    @students = Student.all
  end

  # GET /students/1
  def show; end

  # GET /students/new
  def new
    @student = Student.new
    @student.semester_id = Semester.current&.id
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
      format.html { redirect_to manage_students_path, status: :see_other, notice: t('student.destroyed') }
      format.json { head :no_content }
    end
  end

  # POST /update_uin
  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
  def update_uin
    # Use the extended student lookup logic from the new version
    student = find_logged_in_student

    # If there's no student in the session, but we have an email in the params, try to find the student by email
    if student.nil? && params[:student_email].present?
      student = Student.find_by(email: params[:student_email])
      Rails.logger.debug do
        "UPDATE_UIN Trying to find student by email: #{params[:student_email]}, found: #{student&.id}"
      end
    end

    # Support both teacher lookup methods
    teacher = find_selected_teacher

    # Support both semester parameter styles (object and ID)
    semester_id = params[:semester_id]
    semester_param = params[:semester]

    # Find semester by ID or by name
    semester = if semester_id.present?
                 Semester.find_by(id: semester_id)
               elsif semester_param.present?
                 # Handle semester as a string name if that's how it was previously used
                 Semester.find_by(name: semester_param)
               end

    authenticate = ActiveModel::Type::Boolean.new.cast(params[:authenticate])

    Rails.logger.debug do
      "UPDATE_UIN DEBUG: student=#{student&.id}, teacher=#{teacher&.id}, " \
        "semester=#{semester&.id}, session_user_id=#{session[:user_id]}"
    end

    # If there's still no student but we have teacher and semester, we'll create a new student
    if student.nil? && teacher.present? && semester.present?
      # Generate a placeholder email if not provided
      email = params[:student_email].presence || "student_#{Time.now.to_i}@tamu.edu"

      # Create a new student with the teacher and semester
      student = Student.new(
        first_name: params[:first_name].presence || 'New',
        last_name: params[:last_name].presence || 'Student',
        email: email,
        uin: 123_456_789, # Placeholder UIN meeting the 9-digit requirement
        teacher_id: teacher.id,
        semester_id: semester.id,
        authenticate: authenticate
      )

      Rails.logger.debug { "UPDATE_UIN Creating new student: #{student.inspect}" }

      # Save the student and set the session
      if student.save
        session[:user_id] = student.id
        session[:user_type] = 'student'
        Rails.logger.debug { "UPDATE_UIN Created new student: #{student.id}, setting session" }
        flash[:notice] = t('student.update_uin.success')
      else
        Rails.logger.debug { "UPDATE_UIN Failed to create student: #{student.errors.full_messages.join(', ')}" }
        flash[:alert] = "Failed to register: #{student.errors.full_messages.join(', ')}"
        redirect_to practice_problems_path
        return
      end
    elsif student.nil?
      flash[:alert] = t('student.update_uin.error')
    elsif teacher.present? && semester.present?
      # Update the student with teacher and semester
      # Support both direct teacher assignment and teacher_id
      update_attributes = {
        teacher_id: teacher.id,
        teacher: teacher,
        authenticate: authenticate
      }

      # Handle both semester object and semester_id
      update_attributes[:semester_id] = semester.id if semester.id.present?
      update_attributes[:semester] = semester if semester.present?

      result = student.update(update_attributes)
      Rails.logger.debug { "UPDATE_UIN UPDATE RESULT: #{result}, errors: #{student.errors.full_messages.join(', ')}" }

      # Reload the student to ensure all changes are saved
      student.reload

      # Make sure to set the session for this student
      session[:user_id] = student.id
      session[:user_type] = 'student'

      flash[:notice] = t('student.update_uin.success')
    else
      error_message = if teacher.nil?
                        t('student.update_uin.not_found')
                      elsif semester.nil?
                        t('student.update_uin.semester_not_found')
                      else
                        t('student.update_uin.error')
                      end
      flash[:alert] = error_message
    end

    redirect_to practice_problems_path
  end

  private

  def set_student
    @student = Student.find(params[:id])
  end

  def load_semesters
    @semesters = Semester.active.order(:name)
  end

  def student_params
    params.expect(student: %i[first_name last_name email uin teacher teacher_id
                              authenticate semester semester_id])
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
# rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
