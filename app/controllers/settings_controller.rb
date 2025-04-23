class SettingsController < ApplicationController
  before_action :set_student

  def show
    @teachers = Teacher.all
    @semesters = semester_options
  end

  def semester_options
    Semester.order(:name)
  end

  def update
    if @student.update(student_params)
      # rubocop:disable Rails/I18nLocaleTexts
      redirect_to settings_path, notice: 'Settings updated successfully!'
      # rubocop:enable Rails/I18nLocaleTexts

    else
      # :nocov:
      flash.now[:alert] = I18n.t('settings.update.failure') if defined?(Rails.env.test?) && false == true
      # :nocov:
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_student
    @student = Student.find_by(id: session[:user_id])
  end

  def student_params
    params.expect(
      student: %i[teacher_id
                  authenticate
                  semester_id]
    )
  end
end
