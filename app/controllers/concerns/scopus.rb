module Scopus
  extend ActiveSupport::Concern

  include Network

  def get_scopus_issn_for(id)
    url = Rails.configuration.x.scopus_issn_url + id
    x = Hash.new
    data = go_get(url)
    if data.nil?
      x["hits"] = 0
      return x
    end
    if (data.dig("serial-metadata-response","entry").blank?)
      x["hits"] = 0
    else
      x["hits"] = data.dig("serial-metadata-response","entry").size
      x["data"] = data
    end
    return x
  end

  def scopus_issn_json_for(id)
    unless matches_issn?(id)
      if almost_matches_issn?(id)
        id = id[0..3] + "-" + id[4..7]
      else
        # doesnt match format of ISSN - ignore
        return nil
      end
    end
    url = Rails.configuration.x.scopus_issn_url + id
    return go_get(url)
  end

end
