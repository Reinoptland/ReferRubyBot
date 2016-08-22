module SlackMathbot
  module Commands
    class Calculate < SlackRubyBot::Commands::Base
      command 'calculate' do |client, data, _match|
        words = data.text.split(" ")

        words.each do |word|
          client.say(channel: data.channel, text: word)
        end
      end
    end
  end
end
