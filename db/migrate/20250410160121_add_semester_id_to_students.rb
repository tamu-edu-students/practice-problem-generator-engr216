class AddSemesterIdToStudents < ActiveRecord::Migration[8.0]
  def change
    add_column :students, :semester_id, :integer
    add_index :students, :semester_id
  end
end
