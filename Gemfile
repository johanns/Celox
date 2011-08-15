source 'http://rubygems.org'

gem 'rails', '3.1.0.rc5', :branch => '3-1-stable'
gem 'ruby-debug19', :require => 'ruby-debug'

# Why '2.1.4', and not '2.1.5'? Because: undefined method `visitor' for #<ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
gem 'arel', '2.1.4'

gem 'devise'
gem 'rails_admin', :git => 'git://github.com/sferik/rails_admin.git'

gem 'sqlite3'
gem 'pg'
gem 'thin'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "~> 3.1.0.rc"
  gem 'coffee-rails', "~> 3.1.0.rc"
  gem 'uglifier'
  gem 'compass', :git => 'git://github.com/chriseppstein/compass.git', :branch => 'rails31'
end

gem 'jquery-rails'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end