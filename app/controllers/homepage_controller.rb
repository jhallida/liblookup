class HomepageController < ApplicationController
  def index
    if params[:idfield].present?
      @numhitsdata = get_hits_for_id(params[:idfield])
    end
  end

  private

  def get_hits_for_id(id)
    hits = Hash.new
    hits["Sherpa ISSN"] = sherpa_issn_hits_for(id)
    hits
  end

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

  def sherpa_issn_hits_for(id)
    unless id =~ /^[0-9]{4}-[0-9]{3}[0-9xX]$/
      # doesnt match format of ISSN - ignore
      return 0
    end
    url = Rails.configuration.x.sherpa_url + '?issn=' + id
    unless (Rails.configuration.x.sherpa_api_key.blank?)
      url = url + "&ak=" + Rails.configuration.x.sherpa_api_key
    end
    data = go_get(url)
    if data.nil?
      return 0
    end
    if (data["romeoapi"]["journals"].nil?)
      # bogus ISSN
      return 0
    else
      return data["romeoapi"]["journals"].size
    end
  end

end

