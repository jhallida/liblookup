module Network
  extend ActiveSupport::Concern

  # given a URL return JSON or nil
  def go_get(url)
    begin
      puts "Connecting to URL: " + url
      response = HTTParty.get(url, timeout: Rails.configuration.x.network_time_out)
      data = response.parsed_response
    rescue Exception => e
      puts "Connection ERROR: " + e.message
      return nil
    end
    return data
  end

  # given a URL return raw JSON or XML (depending on what is downloaded) or nil
  def go_get_raw(url)
    begin
      puts "Connecting to URL: " + url
      response = HTTParty.get(url, timeout: Rails.configuration.x.network_time_out)
    rescue Exception => e
      puts "Connection ERROR: " + e.message
      return nil
    end
    return response
  end

end
