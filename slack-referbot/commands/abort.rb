module SlackReferbot
  module Commands
    class Referral < SlackRubyBot::Commands::Base
      command 'abort' do |client, data, match|

        identifier = match['expression']
        redis = Redis.current

        client.say(text: "Are you sure you want to delete #{identifier}?", channel: data.channel)

        client.on :message do |answer|
          client.say(text: "#{answer}", channel: data.channel)

          if /^y/i.match(answer.text)
            redis.del(identifier)

            client.say(text: ["#{identifier} was deleted!", "Feel free to add another referee whenever you feel so inclined :)"], channel: data.channel)
          elsif /^n/i.match(answer)
            client.say(text: ["No problem", "#{identifier} was not deleted"], channel: data.channel)
          else
            client.say(text: ["I didn't quite catch that...", "Please type 'abort <your referee ID here>' to abort the referral process."], channel: data.channel)
          end
        end

        client.say(text: "#{match.inspect}", channel: data.channel)



        client.say(text: "whois #{identifier}", channel: data.channel)
      end
    end
  end
end
