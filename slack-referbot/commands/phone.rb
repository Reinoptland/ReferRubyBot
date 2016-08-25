module SlackReferbot
  module Commands
    class Phonenumber < SlackRubyBot::Commands::Base
      command 'phone' do |client, data, match|
        identifier = match['expression']
        referral = {}

        client.say(text: 'Which phone number may I register?', channel: data.channel)

        client.on :message do |answer|
          $workaround = ""

          if !answer.text.match(/^phone /)
            client.instance_variable_get(:@callbacks)['message'].pop
            referral[:phone] = answer.text

            client.on :message do |answer|
              client.instance_variable_get(:@callbacks)['message'].pop
              referral[:phone] = answer.text
              client.say(text: "Thank you! I have added the phonenumber to the registry.", channel: data.channel)

              Redis.current.mapped_hmset(identifier, referral)
            end
          end
        end
      end
    end #class Phonenumber
  end #Module Commands
end #Module SlackReferbot
