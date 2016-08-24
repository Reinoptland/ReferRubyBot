module SlackReferbot
  module Commands
    class Referral < SlackRubyBot::Commands::Base
      command 'abort' do |client, data, match|
        identifier = match['expression']
        redis = Redis.current

        client.say(text: "#{match.inspect}", channel: data.channel)

        redis.del(identifier)

        client.say(text: "whois #{identifier}", channel: data.channel)
      end
    end
  end
end
