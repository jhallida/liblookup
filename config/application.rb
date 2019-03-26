require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Liblookup
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # amount of time to wait before timing out for each API connection (in seconds)
    config.x.network_time_out = 10

    # key for SHERPA API - optional
    # config.x.sherpa_api_key = "API_KEY_GOES_HERE"

    config.x.sherpa_url = "http://www.sherpa.ac.uk/romeo/api29.php"
    config.x.scopus_issn_url = "https://api.elsevier.com/content/serial/title/issn/"
    config.x.issn_journal_transfer = "https://journaltransfer.issn.org/api"
    config.x.doaj_journal = "https://doaj.org/api/v1/search/journals/"
    config.x.google_books = "https://www.googleapis.com/books/v1/volumes"
    config.x.crossref_journals = "https://api.crossref.org/journals/"
    config.x.open_library = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys="

    config.x.service = ['crossref_issn','sherpa_issn','scopus_issn','issn_transfer','doaj_issn','google_books_isbn', 'openlibrary_isbn', 'openlibrary_lccn']

  end
end
