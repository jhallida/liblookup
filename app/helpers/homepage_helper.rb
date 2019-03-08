module HomepageHelper

  # recursively render JSON / XML data in HTML
  def show_data_for(jsondata)
    if jsondata.nil?
      return ''
    end
    output = "<ul>"
    jsondata.each do |key, value|
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
        # make strings that seem to be URL's automatically cliackable
        if value.to_s.downcase.start_with?("http")
          value = "<a href='" + value + "'>" + value + "</a>"
        end
        output += "<li><b>#{key}:</b> #{value}</li>"
      end
    end
    output += "</ul>"
    return output.html_safe
  end
end
