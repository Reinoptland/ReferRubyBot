module SlackReferbot
  module Commands
    class Email < SlackRubyBot::Commands::Base
      command 'email' do |client, data, match|
        identifier = match['expression']
        referral = {}

        client.say(text: 'Which email may I register?', channel: data.channel)

        client.on :message do |answer|

          $workaround = ""

          if !answer.text.match(/^email /)
            client.instance_variable_get(:@callbacks)['message'].pop
            referral[:email] = answer.text

            client.on :message do |answer|
              client.instance_variable_get(:@callbacks)['message'].pop
              referral[:email] = answer.text
              client.say(text: "Thank you! I have added the email to the registry.", channel: data.channel)

              Redis.current.mapped_hmset(identifier, referral)

            end
          end
        end
      end
    end #class Phonenumber
  end #Module Commands
end #Module SlackReferbot
