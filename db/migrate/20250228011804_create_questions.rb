class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.string :category
      t.string :question
      t.string :answers

      t.timestamps
    end
  end
end
