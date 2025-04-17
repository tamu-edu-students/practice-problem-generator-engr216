module ApplicationHelper
  def format_answer(answer_string)
    # Check if it looks like JSON
    if answer_string.start_with?('{') && answer_string.end_with?('}')
      data = JSON.parse(answer_string)
      # Format as a readable list
      formatted = data.map do |key, value|
        "<strong>#{key.humanize}:</strong> #{value}"
      end

      formatted.join('<br>').html_safe
    else
      # Not JSON, return as is
      answer_string
    end
  rescue StandardError
    # If parsing fails, return original string
    answer_string
  end
end
