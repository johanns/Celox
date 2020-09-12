source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.3.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'

### Databases (uncommend desired database gem)

# Postgres
# gem 'pg'

# MySQL
# gem 'mysql2'

# SQLite
gem 'sqlite3'

###

# HTML / CSS
gem 'slim-rails'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

# Frontend
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'turbolinks', '~> 5'

# ActiveRecord / ActiveModel
gem 'bcrypt', '~> 3.1.7'

# RESTful
gem 'jbuilder', '~> 2.0'

# Documentation
gem 'annotate', group: :development
gem 'sdoc', '~> 1.0.0.rc1', group: :doc

# Background processing...
gem 'sidekiq', '>= 4.2.9'

# Web Server
gem 'puma', '~> 3.12'
gem 'foreman'

# Authentication / Authorization / OAuth
gem 'warden'
gem 'pundit'

# A better Rails console!
gem 'pry-rails'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller', platforms: [:mri_19, :mri_20, :mri_21, :rbx]

  gem 'awesome_print'

  gem 'byebug', platforms: [:mri]
  gem 'web-console', '~> 2.0'
  gem 'meta_request'

  # Profiling...
  gem 'memory_profiler'
  gem 'rack-mini-profiler'
  gem 'flamegraph'
  gem 'stackprof'
end

group :development, :test do
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'bullet'

  # Testing
  gem 'faker'

  # rspec testing...
  gem 'rspec-rails', '~> 3.5'

  # Fixtures
  gem 'factory_girl_rails'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
