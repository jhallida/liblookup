module Sherpa
  extend ActiveSupport::Concern

  include Network

  def get_sherpa_issn_for(id)
    url = Rails.configuration.x.sherpa_url + '?issn=' + id
    x = Hash.new
    unless (Rails.configuration.x.sherpa_api_key.blank?)
      url = url + "&ak=" + Rails.configuration.x.sherpa_api_key
    end
    data = go_get(url)
    if data.nil?
      x["hits"] = 0
    end
    if (data["romeoapi"]["journals"].nil?)
      # bogus ISSN
      x["hits"] = 0
    else
      x["hits"] = data["romeoapi"]["journals"].size
      x["data"] = data
    end
    return x
  end

  #############################################################

  def sherpa_issn_hits_for(id)
    unless matches_issn?(id)
      if almost_matches_issn?(id)
        id = id[0..3] + "-" + id[4..7]
      else
        # doesnt match format of ISSN - ignore
        return 0
      end
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
    unless matches_issn?(id)
      if almost_matches_issn?(id)
        id = id[0..3] + "-" + id[4..7]
      else
        # doesnt match format of ISSN - ignore
        return nil
      end
    end
    url = Rails.configuration.x.sherpa_url + '?issn=' + id
    unless (Rails.configuration.x.sherpa_api_key.blank?)
      url = url + "&ak=" + Rails.configuration.x.sherpa_api_key
    end
    return go_get(url)
  end

  def sherpa_issn_xml_for(id)
    unless matches_issn?(id)
      if almost_matches_issn?(id)
        id = id[0..3] + "-" + id[4..7]
      else
        # doesnt match format of ISSN - ignore
        return nil
      end
    end
    url = Rails.configuration.x.sherpa_url + '?issn=' + id
    unless (Rails.configuration.x.sherpa_api_key.blank?)
      url = url + "&ak=" + Rails.configuration.x.sherpa_api_key
    end
    return go_get_raw(url)
  end

end
