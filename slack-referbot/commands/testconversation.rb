module SlackReferbot
  module Commands
    class TestConversation < SlackRubyBot::Commands::Base
      command 'yes' do |client, data, _match|
        if @@in_conversation
          client.say(channel: data.channel, text: "You have said #{data.text} (YES LOOP)")
        end
      end

      command 'no' do |client, data, _match|
        client.say(channel: data.channel, text: "You have said #{data.text} (NO LOOP)")
      end

      command 'exit' do |client, data, _match|
        client.say(channel: data.channel, text: "You have said #{data.text} (EXIT LOOP)")
      end
    end
  end
end
