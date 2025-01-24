class CreateTeachers < ActiveRecord::Migration[8.0]
  def change
    create_table :teachers do |t|
      t.string :email
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
    add_index :teachers, :email, unique: true
  end
end
