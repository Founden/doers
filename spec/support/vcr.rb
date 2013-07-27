require 'vcr'

VCR.configure do |c|
  c.hook_into :faraday
  c.cassette_library_dir = 'spec/cassettes'
  c.default_cassette_options = { :record => :new_episodes }
  c.ignore_localhost = true
  c.ignore_hosts 'test.example.com', 'fonts.googleapis.com',
    'www.gravatar.com', 's3.amazonaws.com', 'maps.googleapis.com'
  c.configure_rspec_metadata!
  # c.debug_logger = $stdout

  matches_angel_list = lambda { |req|
    req.uri.include?('angel.co') and !req.uri.include?('startup_roles') }

  c.around_http_request(matches_angel_list) do |request|
    VCR.use_cassette('angel_list_oauth2', &request)
  end
end
