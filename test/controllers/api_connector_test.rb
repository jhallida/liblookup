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

  test "should connect to Elsevier/SCOPUS (limited)" do
    url = Rails.configuration.x.scopus_issn_url + '1444-1586'
    begin
      data = HTTParty.get(url, timeout: Rails.configuration.x.network_time_out)
      # data = response.parsed_response
    rescue Exception => e
      assert false
    end
    if (data.dig("serial-metadata-response","entry",0,"dc:title").blank?)
      assert false
    else
      assert true
    end
  end

end