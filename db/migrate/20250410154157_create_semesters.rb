class CreateSemesters < ActiveRecord::Migration[8.0]
  def change
    create_table :semesters do |t|
      t.string :name, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end
    
    add_index :semesters, :name, unique: true
  end
end
