source 'https://rubygems.org'

ruby '2.2.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.4'

gem 'dotenv-rails'

gem 'sprockets', '~> 3.4.0'

# Use mysql as the database for Active Record, development and production envs
# NOTE: due to a bug we need to ensure and old version
#       https://github.com/rails/rails/issues/21544
gem 'mysql2', '~> 0.3.18'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster.
# Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.3'

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'
gem 'bcrypt'

gem 'puma'

gem 'devise'
gem 'devise-async'
gem 'devise_invitable'

gem 'haml'
gem 'haml-rails'

gem 'dust-rails'
gem 'haml_assets'

gem 'foreman'

gem 'yajl-ruby'

gem 'twitter-text'

gem 'metainspector'

gem 'sidekiq'

gem 'sinatra', '>= 1.3.0', require: nil

gem 'simpleconfig'

gem 'redis-rails'

gem 'gon'

gem 'featurer'

gem 'dynamic_sitemaps'

gem 'typhoeus', require: false

group :development do
  gem 'zeus', '~> 0.15.10'
  # version 1.6.0 got yanked, so we need to force the next version
  gem 'html2haml'
  gem 'mixlib-shellout', '~> 1.6.1'
  gem 'rubocop'
  gem 'thin'
end

group :development, :test do
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'guard'
  gem 'guard-jasmine'
  gem 'guard-rspec'
  gem 'jasmine', '2.3.1'
  gem 'jasminerice', git: 'https://github.com/bradphelan/jasminerice.git'
  gem 'poltergeist'
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
end
