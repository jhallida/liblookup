class HomepageController < ApplicationController

  include Network
  include Sherpa
  include Scopus
  include Doaj
  include Issntransfer

  def index
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
  end

  private

  # check all applicable apis and return the number of hits for each one
  def get_hits_for_id(id)
    hits = Hash.new
    hits["Sherpa ISSN"] = sherpa_issn_hits_for(id)
    hits["Scopus ISSN"] = scopus_issn_hits_for(id)
    hits["ISSN Transfer"] = issntransfer_hits_for(id)
    hits["DOAJ ISSN"] = doaj_issn_hits_for(id)
    hits
  end

  # true if id is an issn "0234-567x"
  def matches_issn?(id)
    return id =~ /^[0-9]{4}-[0-9]{3}[0-9xX]$/
  end

  # true if id is an issn with no dash "0234567x"
  def almost_matches_issn?(id)
    return id =~ /^[0-9]{7}[0-9xX]$/
  end

end

