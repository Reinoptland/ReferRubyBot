#!/.env ruby

require 'Twitter'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "drlmupB5gA8mQPaUmOwegXVLk"
  config.consumer_secret     = "B59ozEWkuI4zHrvxqBPReveCUhrsOidzFZhwGLghy0VNREvuo6"
  config.access_token        = "768019056448401408-LFSSNrygICfsUo6AwEKfKCmKkzTtW1k"
  config.access_token_secret = "6nNKIPLLbh5ZtxOb2PvxYpKg4L4oRTdgopIXIA2GSwEvy"
end

client.update("Referbot on twitter!")
