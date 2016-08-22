module SlackMathbot
  class Bot < SlackRubyBot::Bot
    operator '' do |client, data, match|
      words = data.text.split(" ")
      checkvar = false

      words.each do |word|
        if word == "oink"
          checkvar = true
        end
      end

      if checkvar
        client.say(channel: data.channel, text: "Hey piggy, piggy, pig, pig!")
      end
    end
  end
end
