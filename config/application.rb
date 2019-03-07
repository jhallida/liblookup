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
    config.x.network_time_out = 5

    # key for SHERPA API - optional
    # config.x.sherpa_api_key = "API_KEY_GOES_HERE"

    # connection URL for sherpa romeo
    config.x.sherpa_url = "http://www.sherpa.ac.uk/romeo/api29.php"
    config.x.scopus_issn_url = "https://api.elsevier.com/content/serial/title/issn/"

  end
end
