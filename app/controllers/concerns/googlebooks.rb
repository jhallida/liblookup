module Googlebooks
  extend ActiveSupport::Concern

  include Network

  def get_google_books_isbn_for(id)
    url = Rails.configuration.x.google_books + "?q=isbn:" + id
    x = Hash.new
    data = go_get(url)
    if data.nil?
      x["hits"] = 0
      return x
    end
    if data.dig("totalItems").present?
      x["hits"] = data.dig("totalItems").to_i
      x["data"] = data
    else
      x["hits"] = 0
    end
    return x
  end

  def google_books_isbn_json_for(id)
    id = prep_for_isbn_check(id)
    unless matches_isbn?(id)
      # doesnt match format of ISBN - ignore
      return nil
    end
    url = Rails.configuration.x.google_books + "?q=isbn:" + id
    return go_get(url)
  end

end
