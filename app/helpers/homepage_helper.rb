module HomepageHelper

  # recursively render JSON / XML data in HTML
  def show_data_for(jsondata)
    return JSON.pretty_generate(jsondata).html_safe
  end

end
