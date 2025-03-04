class UpdateStudentsSchema < ActiveRecord::Migration[6.1]
  def up
    # Step 1: Add a new temporary column with the desired type (integer)
    add_column :students, :uin_new, :integer

    # Step 2: Copy data from the old 'uin' (string) to the new column
    Student.reset_column_information
    Student.find_each do |student|
      # Convert the string to integer (if conversion fails, to_i returns 0)
      student.update_column(:uin_new, student.uin.to_i)
    end

    # Step 3: Remove the old 'uin' column
    remove_column :students, :uin

    # Step 4: Rename the new column to 'uin'
    rename_column :students, :uin_new, :uin

    # Step 5: Add the new columns required by your new schema
    add_column :students, :teacher, :string
    add_column :students, :teacher_id, :integer
    add_column :students, :authenticate, :boolean, default: false

    # Optionally remove other columns no longer needed
    remove_column :students, :uid if column_exists?(:students, :uid)
    remove_column :students, :provider if column_exists?(:students, :provider)
  end

  def down
    # Reverse the changes made in 'up'
    add_column :students, :uin_new, :string

    Student.reset_column_information
    Student.find_each do |student|
      student.update_column(:uin_new, student.uin.to_s)
    end

    remove_column :students, :uin
    rename_column :students, :uin_new, :uin

    remove_column :students, :teacher
    remove_column :students, :teacher_id
    remove_column :students, :authenticate

    # Re-add uid and provider if needed
    add_column :students, :uid, :string
    add_column :students, :provider, :string
  end
end
