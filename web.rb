require 'sinatra/base'

# This module is needed to run the server
module SlackReferbot
  class Web < Sinatra::Base
    get '/' do
      'Math is good for you.'
    end
  end
end
