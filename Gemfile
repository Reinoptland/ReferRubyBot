source 'http://rubygems.org'

# The bots framework
gem 'slack-ruby-bot'
gem 'slack-ruby-client'


# Puma is the local server
gem 'puma'

# Sinatra is the framework needed for hosting the local server
gem 'sinatra'

# Loads the .env. Needed for the slack api
gem 'dotenv'


# helps in the development enviroment
gem 'eventmachine'

# Needed to run Puma
gem 'faye-websocket'

# http gem helps with http requests to api's
gem 'http'

# json is the file format in which this app communicaties with slack and recruitee
gem 'json'

# Redis is our data structure store
gem 'redis'
gem 'oauth'
gem 'twitter'



group :development, :test do  
  gem 'rake'
  # the development local server
  gem 'foreman'
end

group :test do
  # These gems are needed for the Rspec testing
  gem 'rspec'
  gem 'rack-test'
  gem 'vcr'
  gem 'webmock'
end
