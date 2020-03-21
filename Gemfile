source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'rails', '~> 6.0.0'

gem 'bcrypt', '~> 3.1.7'
gem 'foreman'

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
gem 'jbuilder', '~> 2.7'
gem 'sass-rails', '~> 5'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 4.0'

### Templating
gem 'slim'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

### JSON parser
gem 'oj'
gem 'oj_mimic_json'

### Job Processing
gem 'sucker_punch'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # Documentation
  gem 'annotate'

  # Eager loading helper (speedy sql queries)
  gem 'bullet'

  gem 'awesome_print'
  gem 'brakeman'

  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry-byebug'
  gem 'pry-rails'

  # Static Analyzer & Linter
  gem 'rubocop'
  gem 'rubocop-gitlab-security'
  gem 'rubocop-performance'
  gem 'rubocop-rails'

  # Language Server
  gem 'solargraph'

  gem 'bundler-audit'
  gem 'slim_lint'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
