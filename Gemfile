source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~>5.0.0', '>= 5.0.0.1'
# PostgreSQL adapter
gem 'pg'
# Use ActionModel Serializers for JSON creation
#gem 'active_model_serializers'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 5'
# New Relic Agent
gem 'newrelic_rpm'
# Use unicorn as the app server
gem 'puma', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'dotenv-rails'
end

group :development do
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'codecov', require: false
end

group :production do
  gem 'rails_12factor'
end
