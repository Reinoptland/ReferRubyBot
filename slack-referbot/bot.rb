module SlackReferbot
  class Bot < SlackRubyBot::Bot
    conversation_states = {
      state_in_conversation: false,
      state_get_name: false
    }

    referee = {
      name: '',
      email: ''
    }

    operator '' do |client, data, match|

      client.say(channel: data.channel, text: data.text)

      # User types refer
      if /(^refer| refer)/i.match(data.text) && conversation_states[:state_in_conversation] == false
        # # Get user's DM channel code
        # uri = URI("https://slack.com/api/im.open?token=#{ENV['SLACK_API_TOKEN']}&user=#{data.user}")
        # # Needs reformatting with names to symbol
        # uri_response = JSON.parse(Net::HTTP.get(uri))
        # dm_channel = uri_response["channel"]["id"]

        client.say(channel: data.channel, text: "Hi <@#{data.user}>. Would you like to refer someone to one of our open vacancies?")

        conversation_states[:state_in_conversation] = true
        progression_guard = data.text

      end

      # User is asked to confirm to start referring process
      if /^y/i.match(data.text) && conversation_states[:state_in_conversation]

        client.say(channel: data.channel, text: "Excellent, let's get started!")
        sleep(0.5)
        client.say(channel: data.channel, text: "What is your referee's name?")

        conversation_states[:state_get_name] = true
        progression_guard = data.text

      elsif /^n/i.match(data.text) && conversation_states[:state_in_conversation]
        client.say(channel: data.channel, text: "My bad!")
        sleep(0.5)
        client.say(channel: data.channel, text: "Feel free to contact me any time you want to refer someone to our company!")

        conversation_states[:state_in_conversation] = false

      elsif !/(^y|^n)/i.match(data.text) && progression_guard != data.text && conversation_states[:state_in_conversation] && conversation_states[:state_get_name] == false
        client.say(channel: data.channel, text: "I didn't quite get that... Do you want to refer someone?")

        progression_guard = data.text

      end

      # User is asked to provide a name
      if progression_guard != data.text && conversation_states[:state_get_name]
        referee[:name] << data.text
        client.say(channel: data.channel, text: "#{data.text}, what a lovely name!")

        client.say(channel: data.channel, text: "We will have to contact #{referee[:name]} as well... Do you have an e-mail address?")

      end


    end # Outer operator
  end # Class
end # Module
