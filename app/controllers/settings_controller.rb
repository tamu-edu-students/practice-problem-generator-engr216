class SettingsController < ApplicationController
  def show
    @teachers = Teacher.pluck(:name, :id)
  end
end
