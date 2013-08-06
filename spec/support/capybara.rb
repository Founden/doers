require 'capybara/rspec'
require 'capybara/poltergeist'
require 'billy/rspec'

Capybara.default_driver = :poltergeist_billy
Capybara.javascript_driver = :poltergeist_billy
