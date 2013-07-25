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
