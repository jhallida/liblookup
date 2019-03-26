module Openlibrary
  extend ActiveSupport::Concern

  include Network

  def get_openlibrary_isbn_for(id)
    url = Rails.configuration.x.open_library + 'ISBN:' + id
    x = Hash.new
    data = go_get(url)
    if data.blank?
      x["hits"] = 0
      return x
    end
    x["hits"] = 1
    x["data"] = data
    return x
  end

  def get_openlibrary_lccn_for(id)
    url = Rails.configuration.x.open_library + 'LCCN:' + id
    x = Hash.new
    data = go_get(url)
    if data.blank?
      x["hits"] = 0
      return x
    end
    x["hits"] = 1
    x["data"] = data
    return x
  end

  def openlibrary_isbn_json_for(id)
    id = prep_for_isbn_check(id)
    unless matches_isbn?(id)
      # doesnt match format of ISBN - ignore
      return nil
    end
    url = Rails.configuration.x.open_library + 'ISBN:' + id
    return go_get(url)
  end

  def openlibrary_lccn_json_for(id)
    id = prep_for_isbn_check(id)
    url = Rails.configuration.x.open_library + 'LCCN:' + id
    return go_get(url)
  end

end
