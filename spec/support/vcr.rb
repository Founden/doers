require 'vcr'

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'spec/cassettes'
  c.default_cassette_options = { :record => :none }
  c.ignore_localhost = true
  c.ignore_hosts ['test.example.com', 'fonts.googleapis.com',
                  'www.gravatar.com', 's3.amazonaws.com']
  c.configure_rspec_metadata!
end
