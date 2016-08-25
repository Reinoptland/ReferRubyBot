module SlackReferbot
  class Bot < SlackRubyBot::Bot
    operator '' do |client, data, match|

      case
      when /(^refer| refer)/i.match(data.text)
        uri = URI("https://slack.com/api/im.open?token=#{ENV['SLACK_API_TOKEN']}&user=#{data.user}")

        # Needs reformatting with names to symbol
        uri_response = JSON.parse(Net::HTTP.get(uri))

        dm_channel = uri_response["channel"]["id"]

        client.say(channel: dm_channel, text: "Hi <@#{data.user}>. Would you like to refer someone to one of our open vacancies? You have posted 'refer' to #{data.channel}, which is why I am DMing you at #{dm_channel}.")

      when $workaround == nil

        resp = [ "I yield. I'm only a bot. try typing help",
          "My function is to get your referal. Do you know someone who wants to join our team? Type add *name*",
          "I was made by trainees. You could add improvements to github :)",
          "-bleeb- bleeb- bleeb- unknown command. I accept refer"
        ]

        client.say(text: "#{resp.sample}", channel: data.channel)


      end # RegEx 'refer' listener

      $workaround = nil

    end # Outer operator
  end # Class
end # Module
