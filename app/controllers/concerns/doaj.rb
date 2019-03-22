module Doaj
  extend ActiveSupport::Concern

  include Network

  def get_doaj_issn_for(id)
    url = Rails.configuration.x.doaj_journal + id
    x = Hash.new
    data = go_get(url)
    if data.nil?
      x["hits"] = 0
      return x
    end
    unless data["results"].present?
      x["hits"] = 0
    else
      x["hits"] = 1 # should only ever be 1
      x["data"] = data
    end
    return x
  end

  def doaj_issn_json_for(id)
    unless matches_issn?(id)
      if almost_matches_issn?(id)
        id = id[0..3] + "-" + id[4..7]
      else
        # doesnt match format of ISSN - ignore
        return nil
      end
    end
    url = Rails.configuration.x.doaj_journal + id
    return go_get(url)
  end

end
