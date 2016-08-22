module SlackReferbot
  module Commands
    class Calculate < SlackRubyBot::Commands::Base
      command 'calculate' do |client, data, _match|
        words = data.text.split(" ")
        2.times {words.shift}

        client.say(channel: data.channel, text: words)
      end
    end
  end
end
