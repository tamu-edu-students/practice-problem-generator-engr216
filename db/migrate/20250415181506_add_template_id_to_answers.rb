class AddTemplateIdToAnswers < ActiveRecord::Migration[8.0]
  def change
    # Add the template_id column. Adjust null/default values based on your requirements.
    add_column :answers, :template_id, :integer, null: false, default: 0

    # Create a composite index on [category, template_id] to optimize grouping and queries.
    add_index :answers, [:category, :template_id]
  end
end
