class CreateAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :answers do |t|
      t.integer :question_id
      t.string  :category
      t.string  :question_description
      t.text    :answer_choices # Using text to store serialized data (or JSON)
      t.string  :answer
      t.boolean :correctness
      t.string  :student_email
      t.string  :date_completed
      t.string  :time_spent

      t.timestamps
    end
  end
end
