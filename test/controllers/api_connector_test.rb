require 'test_helper'

class ApiConnectorTest < ActionDispatch::IntegrationTest

  test "should connect to SHERPA/ROMEO" do
    url = Rails.configuration.x.sherpa_url + '?issn=1444-1586'
    unless (Rails.configuration.x.sherpa_api_key.blank?)
      url = url + "&ak=" + Rails.configuration.x.sherpa_api_key
    end
    begin
      response = HTTParty.get(url, timeout: Rails.configuration.x.network_time_out)
      data = response.parsed_response
    rescue Exception => e
      assert false
    end
    if (data["romeoapi"]["journals"].nil?)
      assert false
    else
      assert true
    end
  end

  test "should connect to Elsevier/SCOPUS (limited)" do
    url = Rails.configuration.x.scopus_issn_url + '1444-1586'
    begin
      data = HTTParty.get(url, timeout: Rails.configuration.x.network_time_out)
    rescue Exception => e
      assert false
    end
    if (data.dig("serial-metadata-response","entry",0,"dc:title").blank?)
      assert false
    else
      assert true
    end
  end

  test "should connect to ISSN Journal Transfer service" do
    url = Rails.configuration.x.issn_journal_transfer + '?query=2041-2479'
    begin
      data = HTTParty.get(url, timeout: Rails.configuration.x.network_time_out)
    rescue Exception => e
      assert false
    end
    if (data.dig(0,"contents","journalOnlineISSN").blank?)
      assert false
    else
      assert true
    end
  end

  test "should connect to DOAJ with an ISSN journal search" do
    url = Rails.configuration.x.doaj_journal + '0973-1075'
    begin
      data = HTTParty.get(url, timeout: Rails.configuration.x.network_time_out)
    rescue Exception => e
      assert false
    end
    data = data.parsed_response
    if data["results"].present?
      assert true
    else
      assert false
    end
  end

  test "should connect to CrossRef and do a ISSN search" do
    url = Rails.configuration.x.crossref_journals + '1549-7712'
    begin
      data = HTTParty.get(url, timeout: Rails.configuration.x.network_time_out)
    rescue Exception => e
      assert false
    end
    data = data.parsed_response
    if data.dig("status").present?
      assert true
    else
      assert false
    end
  end

  test "should connect to CrossRef and do a book ISBN search" do
    url = Rails.configuration.x.crossref_books + 'isbn:9781780648903'
    begin
      data = HTTParty.get(url, timeout: Rails.configuration.x.network_time_out)
    rescue Exception => e
      assert false
    end
    data = data.parsed_response
    if data.dig("message","total-results").present?
      if data.dig("message","total-results") > 0
        assert true
      else
        assert false
      end
    else
      assert false
    end
  end

  test "should connect to Google Books API and do an ISBN search" do
    url = Rails.configuration.x.google_books + '?q=isbn:160941411X'
    begin
      data = HTTParty.get(url, timeout: Rails.configuration.x.network_time_out)
    rescue Exception => e
      assert false
    end
    data = data.parsed_response
    if data.dig("totalItems").present?
      if data.dig("totalItems").to_i > 0
        assert true
      else
        assert false
      end
    else
      assert false
    end
  end

  test "should connect to Open Library API and do an ISBN search" do
    url = Rails.configuration.x.open_library + 'ISBN:9780980200447'
    begin
      data = HTTParty.get(url, timeout: Rails.configuration.x.network_time_out)
    rescue Exception => e
      assert false
    end
    data = data.parsed_response
    if data.empty?
      assert false
    else
      assert true
    end
  end

end