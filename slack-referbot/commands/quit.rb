module SlackReferbot
  module Commands
    class Referral < SlackRubyBot::Commands::Base
      command 'quit' do |client, data, match|
        client.say(text: referral.inspect, channel: data.channel)
      end
    end
  end
end
