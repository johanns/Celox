# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

### Core
gem 'bootsnap', '>= 1.1.0', require: false
gem 'dotenv-rails', groups: %i[development test]
gem 'foreman'
gem 'rails', '~> 5.2.0'

### Databases

# PostgresSQL
# gem 'pg', '>= 0.18', '< 2.0'

# MySQL
# gem 'mysql2', '>= 0.4.4', '< 0.6.0'

# SQLite
gem 'sqlite3'

### Webservers
gem 'puma', '~> 3.11'

### Asset Pipeline
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'webpacker'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

### JavaScript
gem 'turbolinks', require: false

### Templating
gem 'fast_jsonapi'
gem 'slim'

### AAA / Security
gem 'bcrypt', '~> 3.1.7'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-oauth2'
gem 'pundit'

### Storage
gem 'aws-sdk-s3', require: false
gem 'mini_magick', '~> 4.8'
gem 'shrine'

### Job Processing
gem 'sidekiq'

### Deployment
gem 'capistrano-rails', group: :development

### Console
gem 'pry-rails'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # Documentation
  gem 'annotate'

  # Eager loading helper (speedy sql queries)
  gem 'bullet'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
