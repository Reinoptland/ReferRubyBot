module SlackMathbot
  class Bot < SlackRubyBot::Bot
    operator '' do |client, data, match|
      response = match.shift
      client.say(channel: data.channel, text: response)
    end
  end
end
