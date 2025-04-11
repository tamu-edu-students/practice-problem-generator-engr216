class AddSemesterToStudents < ActiveRecord::Migration[8.0]
  def change
    add_column :students, :semester, :string, default: 'Unknown', null: false
  end
end
