source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.1.2'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.5.3'
# Use Puma as the app server
gem 'puma', '~> 6.4.2'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.19'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.16.0', require: false
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', '~> 2.0.1'
# To comunicate with AWS's S3 service
gem 'aws-sdk-s3', '~> 1.134'
# To use AWS's lamba service
gem 'aws-sdk-lambda', '~> 1.113'
# To use graphql
gem 'graphql', '~> 2.1.0'
# to generate token
gem 'jwt', '~> 2.7.1'
# To proces async jobs
gem 'sidekiq', '~> 7.1.4'
gem 'redis', '~> 5.0.7'
# To track errors
gem 'rollbar', '~> 3.4'
# To serving assets
gem 'sprockets-rails', '~> 3.4.2'
# To publish messages on Kafka
gem 'waterdrop', '~> 2.6.7'
# To work with a avro schemas
gem 'avro_turf', '~> 1.12.0'
# Online payments
gem 'stripe', '~> 13.0'
# REST client
gem 'httparty', '~> 0.22.0'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  # to work with env variables
  gem 'dotenv-rails', '~> 2.8.1'
  # debugger
  gem 'pry'
end

group :development do
  gem 'listen', '~> 3.8.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'
  # to mount graphql panel
  gem 'graphiql-rails'
  # Code linter
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-graphql', require: false
  # To detect outdated gems
  gem 'bundler-audit'
end

group :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'shoulda-matchers'
  gem 'database_cleaner'
end


# 2. Redis na sztywno
# 3. Nazwa bazy w database.yml
# 4. config.hosts (Blocked host)
