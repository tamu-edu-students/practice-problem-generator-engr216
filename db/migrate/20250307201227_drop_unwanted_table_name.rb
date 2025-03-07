class DropUnwantedTableName < ActiveRecord::Migration[8.0]
  def change
    drop_table :categories
  end
end
