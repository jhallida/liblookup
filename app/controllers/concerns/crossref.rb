module Crossref
  extend ActiveSupport::Concern

  include Network

  def get_crossref_issn_for(id)
    url = Rails.configuration.x.crossref_journals + id
    x = Hash.new
    data = go_get(url)
    if data.nil?
      x["hits"] = 0
    end
    unless data.dig("status").present?
      # bogus ISSN
      x["hits"] = 0
    else
      x["hits"] = 1 # should always be one
      x["data"] = data
    end
    return x
  end

  def crossref_issn_json_for(id)
    unless matches_issn?(id)
      if almost_matches_issn?(id)
        id = id[0..3] + "-" + id[4..7]
      else
        # doesnt match format of ISSN - ignore
        return nil
      end
    end
    url = Rails.configuration.x.crossref_journals + id
    return go_get(url)
  end

end
