module StudentStatisticsHelper
    def chart_data_for_category(category, student)
      if student
        stat = student.student_category_statistics.find_by(category: category)
        correct = stat ? stat.correct_attempts || 0 : 0
        attempts = stat ? stat.attempts || 0 : 0
        incorrect = attempts - correct
        { "Correct" => correct, "Incorrect" => incorrect }
      else
        { "Correct" => 0, "Incorrect" => 0 }
      end
    end
  end
  