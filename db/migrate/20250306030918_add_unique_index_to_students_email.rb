class AddUniqueIndexToStudentsEmail < ActiveRecord::Migration[6.1]
  def change
    add_index :students, :email, unique: true
  end
end