module SlackReferbot
  class Bot < SlackRubyBot::Bot
    operator '' do |client, data, match|
      if /(^refer| refer)/i.match(data.text)
        client.say(channel: data.channel, text: "Would you like to refer someone to one of our open vacancies?")
      end
    end
  end
end
