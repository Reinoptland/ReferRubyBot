module SlackReferbot
  module Commands
    class Referral < SlackRubyBot::Commands::Base
      command 'add' do |client, data, match|
        identifier = match['expression']
        referral = {}

        client.say(text: 'What can I fill in as a first name?', channel: data.channel)

        client.on :message do |answer|

          if !answer.text.match(/^add /)
            client.instance_variable_get(:@callbacks)['message'].pop
            referral[:first_name] = answer.text
            client.say(text: 'Can you also give me the last name?', channel: data.channel)

            client.on :message do |answer|
              client.instance_variable_get(:@callbacks)['message'].pop
              referral[:last_name] = answer.text
              client.say(text: "Thank you! I have added `#{identifier}` to the registry.", channel: data.channel)

              Redis.current.mapped_hmset(identifier, referral)
            end # End client.on
          end # End if
        end # End 'add'

        # client.say(text: 'I also want to know the email adress.', channel: data.channel)
        # client.on :message do |answer|
        #   referral[:email] = answer.text
        # end
        # client.say(text: 'Which phone number may I register?', channel: data.channel)
        # client.on :message do |answer|
        #   referral[:phone] = answer.text
        # end
        # client.say(text: 'Which vacancy can I sign up our candidate for?', channel: data.channel)
        # client.on :message do |answer|
        #   referral[:vacancy] = answer.text
        # end
      end

      command 'whois' do |client, data, match|
        identifier = match['expression']
        redis = Redis.current

        if redis.exists(identifier)
          referral = redis.hgetall(identifier)
          client.say(text: referral.inspect, channel: data.channel)
        else
          client.say(text: "Sorry but I can't find `#{identifier}` in the registry.", channel: data.channel)
        end
      end
    end
  end
end
