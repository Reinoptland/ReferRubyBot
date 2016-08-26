module SlackReferbot
  class Bot < SlackRubyBot::Bot
    conversation_states = {
      in_conversation: false,
      state_name: false}

    operator '' do |client, data, match|

      if /(^refer| refer)/i.match(data.text) && conversation_states[:in_conversation] == false
        # Get user's DM channel code
        uri = URI("https://slack.com/api/im.open?token=#{ENV['SLACK_API_TOKEN']}&user=#{data.user}")
        # Needs reformatting with names to symbol
        uri_response = JSON.parse(Net::HTTP.get(uri))
        @dm_channel = uri_response["channel"]["id"]

        client.say(channel: @dm_channel, text: "Hi <@#{data.user}>. Would you like to refer someone to one of our open vacancies?")

        conversation_states[:in_conversation] = true
      end

      if /^y/i.match(data.text) && conversation_states[:in_conversation]
        client.say(channel: data.channel, text: "Excellent, let's get started!#{@dm_channel}")
        # sleep(0.5)
        # client.say(channel: @dm_channel, text: "What is your referee's name?")

      elsif /^n/i.match(data.text) && conversation_states[:in_conversation]
        client.say(channel: @dm_channel, text: "My bad!")
        # sleep(0.5)
        # client.say(channel: @dm_channel, text: "Feel free to contact me any time you want to refer someone to our company!")
        # conversation_states[:in_conversation] = true

      elsif conversation_states[:in_conversation]
        # client.say(channel: @dm_channel, text: "I didn't quite get that... Do you want to refer someone?")
      end

    end # Outer operator
  end # Class
end # Module
