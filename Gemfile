source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', :github => 'rails/rails'
gem 'gettext_i18n_rails'
gem 'haml-rails'
gem 'easy_auth', :github => 'dockyard/easy_auth', :branch => 'rails4'
gem 'easy_auth-oauth', :github => 'dockyard/easy_auth-oauth'
gem 'easy_auth-twitter', :github => 'dockyard/easy_auth-twitter'
gem 'settingslogic'
gem 'oj'
gem 'sanitize'
gem 'doorkeeper', :github => 'stas/doorkeeper', :branch => 'rails4'

group :production do
  gem 'pg'
  gem 'puma'
end

group :assets do
  gem 'sass-rails', '~> 4.0.0.beta1'
  gem 'coffee-rails', '~> 4.0.0.beta1'
  gem 'uglifier'
  gem 'therubyracer'
  gem 'compass-rails', :github => 'milgner/compass-rails', :branch => 'rails4'
  gem 'zurb-foundation'
  gem 'jquery-rails'
end

group :development do
  gem 'sqlite3'
  gem 'quiet_assets'
  gem 'pry-rails'
  gem 'seedbank'
  gem 'cane', :require => false
  gem 'yard', :require => false
  gem 'erd', :require => false
end

group :development, :test do
  gem 'ffaker'
  gem 'fabrication'
  gem 'rspec-rails'
  gem 'database_cleaner', '~> 1.0.0.RC1'
  gem 'shoulda-matchers', :github => 'thoughtbot/shoulda-matchers'
  gem 'simplecov', :require => false
  gem 'guard-rspec', :require => false
  gem 'rb-inotify', :require => false
  gem 'mina', :require => false
end
