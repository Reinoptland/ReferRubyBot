module SlackReferbot
  module Commands
    class Abort < SlackRubyBot::Commands::Base
      command 'test', 'try' do |client, data, match|
        test_convo = Redis.current.hget('test_hash', 'in_conversation')

        client.say(channel: data.channel, text: test_convo)

        if  test_convo == 'true'
          client.say(channel: data.channel, text: "Beep!")
        end
      end
    end
  end
end
