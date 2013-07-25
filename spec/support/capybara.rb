require 'capybara/rspec'
require 'capybara/poltergeist'

if ENV['TDDIUM'] or ENV['WERCKER']
  Capybara.default_driver = :poltergeist
  Capybara.javascript_driver = :poltergeist
else
  require 'billy/rspec'
  Capybara.default_driver = :poltergeist_billy
  Capybara.javascript_driver = :poltergeist_billy
end

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end

# Forces all threads to share the same connection. This works on
# Capybara because it starts the web server in a thread.
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
