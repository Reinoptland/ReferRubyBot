module SlackReferbot
  module Commands
    class Referral < SlackRubyBot::Commands::Base
      command 'abort' do |client, data, match|
        redis = Redis.current
        referral = redis.hgetall(identifier)

        client.say(text: "#{redis.inspect} #{match.inspect} #{referral}", channel: data.channel)
      end
    end
  end
end
