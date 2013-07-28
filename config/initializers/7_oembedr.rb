require 'oembedr'
require 'typhoeus/adapters/faraday'

Oembedr.configure do |configuration|
  configuration.user_agent = '%s/%s oEmbed client' % [
    Doers::Config.app_owner, Doers::Config.app_id]
  # configuration.adapter = :excon # default :typhoeus
end
