require 'test_helper'

class ApiConnectorTest < ActionDispatch::IntegrationTest

  test "should connect to SHERPA/ROMEO" do
    url = Rails.configuration.x.sherpa_url + '?issn=1444-1586'
    unless (Rails.configuration.x.sherpa_api_key.blank?)
      url = url + "&ak=" + Rails.configuration.x.sherpa_api_key
    end
    begin
      response = HTTParty.get(url, timeout: Rails.configuration.x.network_time_out)
      data = response.parsed_response
    rescue Exception => e
      assert false
    end
    if (data["romeoapi"]["journals"].nil?)
      assert false
    else
      assert true
    end
  end

end