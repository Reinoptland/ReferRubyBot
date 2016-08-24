module SlackReferbot
  class Bot < SlackRubyBot::Bot
    # This clears Redis database on startup
    operator '' do |client, data, match|
      if /(^refer| refer)/i.match(data.text)
        uri = URI("https://slack.com/api/im.open?token=#{ENV['SLACK_API_TOKEN']}&user=#{data.user}")

        # Needs reformatting with names to symbol
        uri_response = JSON.parse(Net::HTTP.get(uri))

        dm_channel = uri_response["channel"]["id"]

        client.say(channel: dm_channel, text: "Hi <@#{data.user}>. Would you like to refer someone to one of our open vacancies? You have posted 'refer' to #{data.channel}, which is why I am DMing you at #{dm_channel}.")

        Redis.current.mapped_hmset('test_hash', {"in_conversation": true})

        client.say(channel: dm_channel, text:  "#{Redis.current.hgetall('test_hash')} oink")
      end # RegEx 'refer' listener
    end # Outer operator
  end # Class
end # Module
