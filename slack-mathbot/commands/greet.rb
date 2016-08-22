module SlackMathbot
  module Commands
    class Greet < SlackRubyBot::Commands::Base
      command 'greet' do |client, data, _match|
        client.say(channel: data.channel, text: 'Hi!')
      end
    end
  end
end
