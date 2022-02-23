source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.1'

### Core
# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.2', '>= 7.0.2.2'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'bootsnap', require: false

### Asset Pipeline + JS Support
gem 'sprockets-rails'
gem 'jsbundling-rails'
gem 'turbo-rails'
gem 'cssbundling-rails'

### Database
gem 'sqlite3', '~> 1.4'
# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

### Templating
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'oj'
gem 'jbuilder'
gem 'slim', '~> 4.1'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  # Documentation
  gem 'annotate'

  # Eager loading helper (speedy sql queries)
  gem 'bullet'

  gem 'awesome_print'

  gem 'better_errors'
  gem 'binding_of_caller'

  # Static Analyzer & Linter
  gem 'brakeman'
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
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end
