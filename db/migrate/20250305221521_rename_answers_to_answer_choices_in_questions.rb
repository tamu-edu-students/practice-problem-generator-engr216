class RenameAnswersToAnswerChoicesInQuestions < ActiveRecord::Migration[8.0]
  def change
    rename_column :questions, :answers, :answer_choices
  end
end
