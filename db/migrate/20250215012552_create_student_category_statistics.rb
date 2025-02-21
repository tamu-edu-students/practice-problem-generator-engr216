class CreateStudentCategoryStatistics < ActiveRecord::Migration[8.0]
  def change
    create_table :student_category_statistics do |t|
      t.references :student, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.integer :attempts
      t.integer :correct_attempts

      t.timestamps
    end
  end
end
