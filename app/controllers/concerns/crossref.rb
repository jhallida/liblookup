module Crossref
  extend ActiveSupport::Concern

  include Network

  def get_crossref_issn_for(id)
    url = Rails.configuration.x.crossref_journals + id
    x = Hash.new
    data = go_get(url)
    if data.nil? || data.class==String
      x["hits"] = 0
      return x
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

  def get_crossref_isbn_for(id)
    url = Rails.configuration.x.crossref_books + 'isbn:' + id
    x = Hash.new
    data = go_get(url)
    if data.nil? || data.class==String
      x["hits"] = 0
      return x
    end
    if data.dig("message","total-results").present?
      x["hits"] = data.dig("message","total-results")
      x["data"] = data
    else
      x["hits"] = 0
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

  def crossref_isbn_json_for(id)
    id = prep_for_isbn_check(id)
    unless matches_isbn?(id)
      # doesnt match format of ISBN - ignore
      return nil
    end
    url = Rails.configuration.x.crossref_books + 'isbn:' + id
    return go_get(url)
  end

end
