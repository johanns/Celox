source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'

# Databases
gem 'sqlite3'

# JavaScript / Frontend Scripting
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'turbolinks'

# RESTful
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

# ActiveRecord / ActiveModel
gem 'bcrypt', '~> 3.1.7'

# Haml / HTML / CSS
gem 'slim-rails'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'neatjson'
gem 'font-awesome-rails'

# Web Server
gem 'puma'

# Runtime
gem 'foreman'

# Background processing & scheduling
gem 'sucker_punch', '~> 1.0'
gem 'clockwork'

# Better logging
gem 'awesome_print'

# Debugging
group :development do
  gem 'spring'
  gem 'better_errors'
  gem 'binding_of_caller', platforms: [:mri_19, :mri_20, :mri_21, :rbx]
  gem 'html2haml'
  gem 'quiet_assets'
  gem 'meta_request'
  gem 'syntax'
end

group :development, :test do
  gem 'jazz_hands', github: 'nixme/jazz_hands', branch: 'bring-your-own-debugger'
  gem 'pry-byebug'

  gem 'byebug'
  gem 'web-console', '~> 2.0'
end