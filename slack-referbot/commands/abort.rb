module SlackReferbot
  module Commands
    class Abort < SlackRubyBot::Commands::Base
      command 'abort', 'delete' do |client, data, match|

        identifier = match['expression']
        redis = Redis.current

        client.say(text: "Are you sure you want to delete #{identifier}?", channel: data.channel)

#        client.on :message do |answer|
          client.say(text: "answer.text: #{answer.text} client.on: #{client.on :message}", channel: data.channel)

          if /^y/i.match(answer.text)
            redis.del(identifier)

            client.say(text: ["#{identifier} was deleted!", "Feel free to add another referee whenever you feel so inclined :)"], channel: data.channel)

            logger.info "BLA"
            break
          elsif /^n/i.match(answer.text)
            client.say(text: ["No problem", "#{identifier} was not deleted"], channel: data.channel)
          elsif !(/(^y|^n)/i.match(answer.text)) # Answer does not begin with 'y' or 'n'
            client.say(text: ["I didn't quite catch that...", "Please type 'abort <your referee ID here>' to abort the referral process."], channel: data.channel)
          end # if
#        end # client.on
        break
      end # command
    end # Abort
  end # Commands
end # SlackReferbot
