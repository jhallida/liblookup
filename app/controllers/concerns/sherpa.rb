module Sherpa
  extend ActiveSupport::Concern

  include Network

  # true if id is an issn
  def matches_sherpa_issn?(id)
    return id =~ /^[0-9]{4}-[0-9]{3}[0-9xX]$/
  end

  def sherpa_issn_hits_for(id)
    unless matches_sherpa_issn?(id)
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

  def sherpa_issn_json_for(id)
    unless matches_sherpa_issn?(id)
      # doesnt match format of ISSN - ignore
      return nil
    end
    url = Rails.configuration.x.sherpa_url + '?issn=' + id
    unless (Rails.configuration.x.sherpa_api_key.blank?)
      url = url + "&ak=" + Rails.configuration.x.sherpa_api_key
    end
    return go_get(url)
  end

  def sherpa_issn_xml_for(id)
    unless id =~ /^[0-9]{4}-[0-9]{3}[0-9xX]$/
      # doesnt match format of ISSN - ignore
      return nil
    end
    url = Rails.configuration.x.sherpa_url + '?issn=' + id
    unless (Rails.configuration.x.sherpa_api_key.blank?)
      url = url + "&ak=" + Rails.configuration.x.sherpa_api_key
    end
    return go_get_raw(url)
  end

end
