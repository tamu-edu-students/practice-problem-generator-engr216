class AddIndexToStudentsEmail < ActiveRecord::Migration[8.0]
  def change
    add_index :students, :email, unique: true
  end
end 