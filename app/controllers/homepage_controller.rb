class HomepageController < ApplicationController

  include Network
  include Sherpa
  include Scopus
  include Doaj
  include Issntransfer
  include Googlebooks
  include Crossref

  def index
    if params[:idfield].present?
      get_data_for_id(params[:idfield])
    else
      @returndata = nil
    end
  end

  # collect all the data from the APIs that match the query
  def get_data_for_id(id)
    @returndata = Hash.new
    issn = fix_issn(id)
    unless issn.nil?
      @returndata["sherpa_issn"] = get_sherpa_issn_for(params[:idfield])
    end
  end

  # given an id, return the id if it's an issn (formatted correctly), or return nil if not
  def fix_issn(id)
    if matches_issn?(id)
      return id
    end
    if almost_matches_issn?(id)
      id = id[0..3] + "-" + id[4..7]
      return id
    end
    return nil
  end

  # true if id is an issn "0234-567x"
  def matches_issn?(id)
    return id =~ /^[0-9]{4}-[0-9]{3}[0-9xX]$/
  end

  # true if id is an issn with no dash "0234567x"
  def almost_matches_issn?(id)
    return id =~ /^[0-9]{7}[0-9xX]$/
  end

  ##############

  def index2
    if params[:idfield].present?
      @numhitsdata = get_hits_for_id(params[:idfield])
      unless params[:api].blank?
        # we are returning data of some sort - figure out what it is and show it
        if params[:api]=='sherpa_issn'
          @returndata = {sherpa_issn: sherpa_issn_json_for(params[:idfield])}
        end
        if params[:api]=='scopus_issn'
          @returndata = {scopus_issn: scopus_issn_json_for(params[:idfield])}
        end
        if params[:api]=='issn_transfer'
          @returndata = {issn_transfer: issntransfer_json_for(params[:idfield])}
        end
        if params[:api]=='doaj_issn'
          @returndata = {doaj_issn: doaj_issn_json_for(params[:idfield])}
        end
        if params[:api]=='crossref_issn'
          @returndata = {crossref_issn: crossref_issn_json_for(params[:idfield])}
        end
        if params[:api]=='google_books_isbn'
          @returndata = {google_books_isbn: google_books_isbn_json_for(params[:idfield])}
        end
      end
    end
  end

  def downloadaction
    if params[:api]=='sherpa_issn'
      xmldata = sherpa_issn_xml_for(params[:idfield])
      send_data xmldata, :filename => "SHERPA-ROMEO-ISSN-data-for-" + params[:idfield] + '.xml'
    end
    if params[:api]=='scopus_issn'
      jsondata = scopus_issn_json_for(params[:idfield])
      send_data jsondata, :filename => "Scopus-limited-ISSN-data-for-" + params[:idfield] + '.json'
    end
    if params[:api]=='issn_transfer'
      jsondata = issntransfer_json_for(params[:idfield])
      send_data jsondata, :filename => "ISSN-transfer-data-for-" + params[:idfield] + '.json'
    end
    if params[:api]=='doaj_issn'
      jsondata = doaj_issn_json_for(params[:idfield])
      send_data jsondata, :filename => "DOAJ-ISSN-data-for-" + params[:idfield] + '.json'
    end
    if params[:api]=='crossref_issn'
      jsondata = crossref_issn_json_for(params[:idfield])
      send_data jsondata, :filename => "CrossRef-ISSN-data-for-" + params[:idfield] + '.json'
    end
    if params[:api]=='google_books_isbn'
      jsondata = google_books_isbn_json_for(params[:idfield])
      send_data jsondata, :filename => "Google-Books-ISBN-data-for-" + params[:idfield] + '.json'
    end
  end

  private

  # check all applicable apis and return the number of hits for each one
  def get_hits_for_id(id)
    hits = Hash.new
    hits["Sherpa ISSN"] = sherpa_issn_hits_for(id)
    hits["Scopus ISSN"] = scopus_issn_hits_for(id)
    hits["ISSN Transfer"] = issntransfer_hits_for(id)
    hits["DOAJ ISSN"] = doaj_issn_hits_for(id)
    hits["CROSSREF ISSN"] = crossref_issn_hits_for(id)
    hits["GOOGLE BOOKS ISBN"] = google_books_isbn_hits_for(id)
    hits
  end

  # true if matches ISBN (must be stripped of dashes and spaces already)
  def matches_isbn?(id)
    if id =~ /^[0-9]{10}$/
      return true
    end
    if id =~ /^[0-9]{13}$/
      return true
    end
    return false
  end

  # remove spaces and dashes, in preparation for determining if a string is an isbn number
  def prep_for_isbn_check(id)
    id = id.strip
    id = id.gsub("-","")
    return id
  end

end

