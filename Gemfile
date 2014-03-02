source 'https://rubygems.org'
ruby '2.1.0'

gem 'rails'
gem 'gettext_i18n_rails', '0.10.1'
gem 'haml-rails'
gem 'easy_auth', :github => 'dockyard/easy_auth'
gem 'easy_auth-oauth2', :github => 'stas/easy_auth-oauth2', :branch => 'update_to_easy_auth_master'
gem 'easy_auth-angel_list', :github => 'geekcelerator/easy_auth-angel_list'
gem 'readwritesettings'
gem 'oj'
gem 'sanitize'
gem 'active_model_serializers'
gem 'paperclip'
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'pg'
gem 'oembedr'
gem 'gutentag'
gem 'zip', :require => false
gem 'tubesock'
gem 'roadie'

group :production do
  gem 'puma'
  gem 'party_foul'
  gem 'aws-sdk'
  gem 'daemons'
  gem 'intercom-rails'
  gem 'dalli'
  gem 'websocket-native'
  gem 'newrelic_rpm'
end

group :assets do
  gem 'sprockets-rails'
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'therubyracer'
  gem 'hamlbars'
  gem 'jquery-rails'
  gem 'ember-rails'
  gem 'ember-source'
  gem 'ember-data-source', '~> 1.0.0.beta'
  gem 'bourbon'
  gem 'normalize-rails'
  gem 'momentjs-rails'
  gem 'nprogress-rails'
  gem 'chartjs-rails'
  gem 'heroku'
end

group :development do
  gem 'quiet_assets'
  gem 'seedbank', :github => 'james2m/seedbank'
  gem 'cane', :require => false
  gem 'yard', :require => false
  gem 'erd', :require => false
  gem 'mina', :require => false, :github => 'nadarei/mina'
  gem 'mina-rbenv-addons', :require => false
  gem 'letter_opener'
  gem 'pry-rails'
  gem 'brakeman', :require => false
  gem 'guard-rspec', :require => false
  gem 'guard-migrate', :require => false
  gem 'newrelic_rpm'
end

group :development, :test do
  gem 'ffaker'
  gem 'fabrication', '2.8.1'
  gem 'rspec-rails'
end

group :test do
  gem 'vcr'
  gem 'poltergeist'
  gem 'puffing-billy'
  gem 'database_rewinder'
  gem 'shoulda-matchers'
  gem 'simplecov', :require => false
  gem 'parallel_tests', :require => false
  gem 'timecop'
  gem 'capybara-puma'
end
