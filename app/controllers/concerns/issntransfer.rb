module Issntransfer
  extend ActiveSupport::Concern

  include Network

  def get_issn_transfer_for(id)
    url = Rails.configuration.x.issn_journal_transfer + '?query=' + id
    x = Hash.new
    data = go_get(url)
    if data.nil?
      x["hits"] = 0
      return x
    end
    if (data.dig(0,"contents").blank?)
      x["hits"] = 0
    else
      x["hits"] = 1 # should only ever be 1
      x["data"] = data
    end
    return x
  end

  def issntransfer_json_for(id)
    unless matches_issn?(id)
      if almost_matches_issn?(id)
        id = id[0..3] + "-" + id[4..7]
      else
        # doesnt match format of ISSN - ignore
        return nil
      end
    end
    url = Rails.configuration.x.issn_journal_transfer + '?query=' + id
    return go_get(url)
  end

end
