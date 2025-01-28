class AddUidAndProviderToStudents < ActiveRecord::Migration[8.0]
  def change
    add_column :students, :uid, :string
    add_column :students, :provider, :string
  end
end
