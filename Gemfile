source 'http://rubygems.org'

gem 'rails', '3.2.11'

group :development do
  gem 'sqlite3'
end

group :assets do
  gem 'sass-rails',   '>= 3.1.5'
  gem 'coffee-rails', '>= 3.1.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'twitter-bootstrap-rails', '>= 2.1.3'
end

gem 'jquery-rails'

group :test do
  # Pretty printed test output
  gem 'turn', '~> 0.8.3', :require => false
end

#### My Gems
gem 'pg'

# Application server
gem 'thin', '>= 1.3.1'

# Detects browser locale, and serves appropriate I18n translation
gem 'locale_detector', '>= 0.3.1'

# Manage cron jobs (see /lib/tasks/cron.rake)
gem 'whenever', '>= 0.7.2'

# Deploy automation
gem 'capistrano', '>= 2.9.0'
