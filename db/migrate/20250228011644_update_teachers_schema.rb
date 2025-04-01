class UpdateTeachersSchema < ActiveRecord::Migration[6.1]
  def up
    # Combine first_name and last_name into a new "name" column.
    add_column :teachers, :name, :string

    # If you want to migrate existing data:
    Teacher.reset_column_information
    Teacher.find_each do |teacher|
      teacher.update_column(:name, [teacher.first_name, teacher.last_name].compact.join(' '))
    end

    # Remove first_name, last_name, uid, and provider if they are no longer needed.
    remove_column :teachers, :first_name if column_exists?(:teachers, :first_name)
    remove_column :teachers, :last_name if column_exists?(:teachers, :last_name)
    remove_column :teachers, :uid if column_exists?(:teachers, :uid)
    remove_column :teachers, :provider if column_exists?(:teachers, :provider)
  end

  def down
    # Reverse changes: add first_name and last_name back (data may be lost) and remove name.
    add_column :teachers, :first_name, :string unless column_exists?(:teachers, :first_name)
    add_column :teachers, :last_name, :string unless column_exists?(:teachers, :last_name)
    remove_column :teachers, :name
    # Optionally, re-add uid and provider if needed.
  end
end
