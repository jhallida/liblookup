module HomepageHelper

  # recursively render JSON / XML data in HTML
  def show_data_for(jsondata)
    output = "<ul>"
    jsondata.each do |key, value|
      # make strings that seem to be URL's automatically cliackable
      if (key.downcase.end_with?("url"))
        value = "<a href='" + value + "'>" + value + "</a>"
      end
      if value.is_a?(Hash)
        output += "<li><b>#{key}:</b>"
        output += show_data_for(value)
        output += "</li>"
      elsif value.is_a?(Array)
        output += "<li><b>#{key}:</b><ul>"
        value.each do |value|
          if value.is_a?(String)
            output += "<li>#{value}</li>"
          else
            output += show_data_for(value)
          end
        end
        output += "</ul></li>"
      else
        output += "<li><b>#{key}:</b> #{value}</li>"
      end
    end
    output += "</ul>"
    return output.html_safe
  end
end
