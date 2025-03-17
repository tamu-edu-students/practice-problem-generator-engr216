class AddUniqueIndexToStudentsEmail < ActiveRecord::Migration[8.0]
  def change
    unless index_exists?(:students, :email, name: "index_students_on_email")
      add_index :students, :email, unique: true, name: "index_students_on_email"
    end
  end
end