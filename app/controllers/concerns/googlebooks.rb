module Googlebooks
  extend ActiveSupport::Concern

  include Network

  def google_books_isbn_hits_for(id)
    id = prep_for_isbn_check(id)
    unless matches_isbn?(id)
      # doesnt match format of ISBN - ignore
      return 0
    end
    url = Rails.configuration.x.google_books + "?q=isbn:" + id
    data = go_get(url)
    if data.nil?
      return 0
    end
    if data.dig("totalItems").present?
      return data.dig("totalItems").to_i
    else
      return 0
    end
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
