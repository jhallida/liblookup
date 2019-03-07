module Issntransfer
  extend ActiveSupport::Concern

  include Network

  def issntransfer_hits_for(id)
    unless matches_issn?(id)
      if almost_matches_issn?(id)
        id = id[0..3] + "-" + id[4..7]
      else
        # doesnt match format of ISSN - ignore
        return 0
      end
    end
    url = Rails.configuration.x.issn_journal_transfer + '?query=' + id
    data = go_get(url)
    if data.nil?
      return 0
    end
    if (data.dig(0,"contents").blank?)
      # bogus ISSN
      return 0
    else
      # I think this is only ever one
      return 1
    end
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
    data = go_get(url)
  end

end
