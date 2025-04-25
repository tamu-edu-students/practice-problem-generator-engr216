module ApplicationHelper
  def format_answer(answer_string)
    # Check if it looks like JSON
    if answer_string.start_with?('{') && answer_string.end_with?('}')
      begin
        data = JSON.parse(answer_string)
        # Format as a readable list using safe methods
        formatted = data.map do |key, value|
          content_tag(:strong, "#{key.humanize}:") + " #{h(value)}"
        end

        safe_join(formatted, tag.br)
      rescue JSON::ParserError
        # If parsing fails, return escaped original string
        h(answer_string)
      end
    else
      # Not JSON, return escaped string
      h(answer_string)
    end
  rescue StandardError
    # If any other error occurs, return escaped original string
    h(answer_string)
  end
end
