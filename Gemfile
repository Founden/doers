source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '~> 4.0.0.beta1'
gem 'gettext_i18n_rails'
gem 'haml-rails'

group :production do
  gem 'pg'
  gem 'puma'
end

group :assets do
  gem 'uglifier'
  gem 'therubyracer'
  gem 'compass-rails', :github => 'milgner/compass-rails', :branch => 'rails4'
  gem 'zurb-foundation'
end

group :development do
  gem 'sqlite3'
  gem 'quiet_assets'
  gem 'pry-rails'
  gem 'seedbank'
  gem 'cane', :require => false
  gem 'yard', :require => false
end

group :development, :test do
  gem 'ffaker'
  gem 'fabrication'
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'simplecov', :require => false
  gem 'guard-rspec', :require => false
  gem 'rb-inotify', :require => false
end
