module Scopus
  extend ActiveSupport::Concern

  include Network

  def scopus_issn_hits_for(id)
    unless matches_issn?(id)
      if almost_matches_issn?(id)
        id = id[0..3] + "-" + id[4..7]
      else
        # doesnt match format of ISSN - ignore
        return 0
      end
    end
    url = Rails.configuration.x.scopus_issn_url + id
    data = go_get(url)
    if data.nil?
      return 0
    end
    if (data.dig("serial-metadata-response","entry").blank?)
      # bogus ISSN
      return 0
    else
      return data.dig("serial-metadata-response","entry").size
    end
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
