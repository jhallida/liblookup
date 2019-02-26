class HomepageController < ApplicationController

  include Network
  include Sherpa

  def index
    if params[:idfield].present?
      if params[:api].blank?
        # we are looking for number of hits only
        @numhitsdata = get_hits_for_id(params[:idfield])
      else
        # we are returning data of some sort - figure out what it is and show it
        if params[:api]=='sherpa_issn'
          @returndata = sherpa_issn_json_for(params[:idfield])
        end
      end
    end
  end

  def downloadaction
    if params[:api]=='sherpa_issn'
      xmldata = sherpa_issn_xml_for(params[:idfield])
      send_data xmldata, :filename => "SHERPA-ROMEO-ISSN-data-for-" + params[:idfield] + '.xml'
    end
  end

  private

  # check all applicable apis and return the number of hits for each one
  def get_hits_for_id(id)
    hits = Hash.new
    hits["Sherpa ISSN"] = sherpa_issn_hits_for(id)
    hits
  end

end

