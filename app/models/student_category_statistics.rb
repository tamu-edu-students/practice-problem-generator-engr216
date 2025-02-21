class StudentCategoryStatistics < ApplicationRecord
  self.table_name = "student_category_statistics"  # Specify the table name if it doesn’t follow the pluralization

  belongs_to :student
  belongs_to :category

  def accuracy
    attempts.zero? ? 0 : (correct_attempts.to_f / attempts * 100).round(2)
  end
end
