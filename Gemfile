# frozen_string_literal: true

source "https://rubygems.org"

### Core ###

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.3"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Use sqlite3 as the database for Active Record
gem "sqlite3", ">= 2.1"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[windows jruby]

# Use the database-backed adapters for Rails.cache and Active Job
gem "solid_cache"
gem "solid_queue"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

### Frontend ###

gem "better_html"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Use Tailwind CSS [https://github.com/rails/tailwindcss-rails]
gem "tailwindcss-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Test framework for Rails [https://rspec.info/]
  gem "rspec-rails", "~> 8.0.0"

  # Factory framework for Ruby objects [https://github.com/thoughtbot/factory_bot]
  gem "factory_bot_rails"

  # Generate fake data for testing [https://github.com/faker-ruby/faker]
  gem "faker"

  # Simple one-liner tests for common Rails functionality [https://github.com/thoughtbot/shoulda-matchers]
  gem "shoulda-matchers"

  # Linters

  gem "erb_lint", require: false

  gem "erb-formatter", require: false

  gem "rubocop", require: false
  gem "rubocop-erb", require: false
  gem "rubocop-factory_bot", require: false
  gem "rubocop-faker", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-rspec_rails", require: false
  gem "rubocop-thread_safety", require: false
end

group :development do
  gem "annotaterb", require: false

  gem "rack-mini-profiler", require: false

  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end
