class AddSectionToStudents < ActiveRecord::Migration[8.0]
  def change
    add_column :students, :section, :string
  end
end
