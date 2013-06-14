source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', :github => 'rails/rails'
gem 'gettext_i18n_rails'
gem 'haml-rails'
gem 'easy_auth', :github => 'stas/easy_auth', :branch => 'rails4'
gem 'easy_auth-oauth2', :github => 'dockyard/easy_auth-oauth2'
gem 'easy_auth-angel_list', :github => 'geekcelerator/easy_auth-angel_list'
gem 'readwritesettings'
gem 'oj'
gem 'sanitize'
gem 'active_model_serializers'
gem 'paperclip'
  gem 'intercom-rails'

group :production do
  gem 'pg'
  gem 'puma'
  gem 'party_foul'
  gem 'aws-sdk'
end

group :assets do
  gem 'sprockets-rails'
  gem 'sass-rails', '~> 4.0.0.rc1'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'therubyracer'
  gem 'compass', '0.13.alpha.4'
  gem 'zurb-foundation'
  gem 'jquery-rails', '2.2.1'
  gem 'handlebars-source', '1.0.0.rc4'
  gem 'hamlbars'
  gem 'ember-rails', :github => 'emberjs/ember-rails'
end

group :development do
  gem 'quiet_assets'
  gem 'seedbank'
  gem 'cane', :require => false
  gem 'yard', :require => false
  gem 'erd', :require => false
  gem 'mina', :require => false, :github => 'nadarei/mina'
  gem 'simplecov', :require => false
  gem 'pry-rails'
end

group :development, :test do
  gem 'sqlite3'
  gem 'ffaker'
  gem 'fabrication'
  gem 'rspec', '~> 2.14.0.rc1', :require => false
  gem 'rspec-rails', '~> 2.14.0.rc1'
  gem 'guard-rspec', :require => false
  gem 'rb-inotify', :require => false
end

group :test do
  gem 'vcr'
  gem 'webmock'
  gem 'poltergeist'
  gem 'puffing-billy'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
end
