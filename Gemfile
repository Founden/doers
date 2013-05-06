source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', :github => 'rails/rails'
gem 'gettext_i18n_rails'
gem 'haml-rails'
gem 'easy_auth', :github => 'stas/easy_auth', :branch => 'rails4'
gem 'easy_auth-oauth', :github => 'dockyard/easy_auth-oauth'
gem 'easy_auth-twitter', :github => 'dockyard/easy_auth-twitter'
gem 'settingslogic'
gem 'oj'
gem 'sanitize'

group :production do
  gem 'pg'
  gem 'puma'
end

group :assets do
  gem 'sprockets-rails', '~> 2.0.0.rc4'
  gem 'sass-rails', '~> 4.0.0.rc1'
  gem 'coffee-rails', '~> 4.0.0'
  gem 'uglifier'
  gem 'therubyracer'
  gem 'compass', '0.13.alpha.4'
  gem 'zurb-foundation'
  gem 'jquery-rails'
  gem 'handlebars-source', '~> 1.0.0.rc3 '
  gem 'hamlbars'
  gem 'ember-rails', :github => 'emberjs/ember-rails'
end

group :development do
  gem 'quiet_assets'
  gem 'seedbank'
  gem 'cane', :require => false
  gem 'yard', :require => false
  gem 'erd', :require => false
  gem 'mina', :require => false
end

group :development, :test do
  gem 'sqlite3'
  gem 'pry-rails'
  gem 'ffaker'
  gem 'fabrication'
  gem 'guard-rspec', :require => false
  gem 'rb-inotify', :require => false
end

group :test do
  gem 'rspec-rails'
  gem 'vcr'
  gem 'webmock'
  gem 'capybara-webkit', :github => 'thoughtbot/capybara-webkit'
  gem 'database_cleaner', '~> 1.0.0.RC1'
  gem 'shoulda-matchers', :github => 'thoughtbot/shoulda-matchers'
  gem 'simplecov', :require => false
end
