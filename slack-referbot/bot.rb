module SlackReferbot
  class Bot < SlackRubyBot::Bot
    conversation_states = {
      state_in_conversation: false,
      state_get_name: false,
      state_get_email: false,
      state_get_vacancy: false,
      state_input_gathered: false
    }

    referee = {
      name: '',
      email: ''
    }

    operator '' do |client, data, match|
      # User types refer
      if /(^refer| refer)/i.match(data.text) && conversation_states[:state_in_conversation] == false
        # # Get user's DM channel code
        # uri = URI("https://slack.com/api/im.open?token=#{ENV['SLACK_API_TOKEN']}&user=#{data.user}")
        # # Needs reformatting with names to symbol
        # uri_response = JSON.parse(Net::HTTP.get(uri))
        # dm_channel = uri_response["channel"]["id"]

        client.say(channel: data.channel, text: "Hi <@#{data.user}>. Would you like to refer someone to one of our open vacancies?")

        conversation_states[:state_in_conversation] = true
        data.text = ''

      end

      # User is asked to confirm to start referring process
      if /^y/i.match(data.text) && conversation_states[:state_in_conversation]

        client.say(channel: data.channel, text: "Excellent, let's get started!")
        sleep(0.5)
        client.say(channel: data.channel, text: "What is your referee's name?")

        conversation_states[:state_get_name] = true
        data.text = ''

      elsif /^n/i.match(data.text) && conversation_states[:state_in_conversation]
        client.say(channel: data.channel, text: "My bad!")
        sleep(0.5)
        client.say(channel: data.channel, text: "Feel free to contact me any time you want to refer someone to our company!")

        conversation_states[:state_in_conversation] = false

      elsif !/(^y|^n)/i.match(data.text) && data.text != '' && conversation_states[:state_in_conversation] && conversation_states[:state_get_name] == false
        client.say(channel: data.channel, text: "I didn't quite get that... Do you want to refer someone?")

        data.text = ''

      end

      # User is asked to provide a name...
      if data.text != '' && conversation_states[:state_get_name] && !conversation_states[:state_get_email]
        referee[:name] << data.text
        client.say(channel: data.channel, text: "#{referee[:name].capitalize}, what a lovely name!")

        client.say(channel: data.channel, text: "We will have to contact #{referee[:name]} as well... Do you have an e-mail address?")

        conversation_states[:state_get_email] = true
        data.text = ''

      end

      # ... email...
      if data.text != '' && conversation_states[:state_get_email] && !conversation_states[:state_get_vacancy]
        referee[:email] << data.text

        client.say(channel: data.channel, text: "Great! Let me show you a list of vacancies that we are looking to fill.")

        getlist

        client.say(channel: data.channel, text: "Please enter the vacancy that you would like to recommend #{referee[:name]} for. If you think an open application would be more appropriate, just type 0!")

        conversation_states[:state_get_vacancy] = true
        data.text = ''
      end

      # ... vacancy...
      if data.text != '' && conversation_states[:state_get_vacancy] && !conversation_states[:state_input_gathered]
        referee[:vacancy] << data.text

        conversation_states[:state_input_gathered] = true
        data.text = ''
      end

      if conversation_states[:state_input_gathered]
        client.say(channel: data.channel, text: "Awesome! You have finished referring #{referee[:name]} for the job of #{referee[:vacancy]}. We'll initiate contact at #{referee[:email]} as soon as possible!")

        conversation_states[:state_in_conversation] = false
        conversation_states[:state_get_name] = false
        conversation_states[:state_get_email] = false
        conversation_states[:state_get_vacancy] = false
        conversation_states[:state_input_gathered] = false

        broadcast_to_general
      end

    end # Outer operator
  end # Class
end # Module

def getlist
  receivelist = HTTP.get('https://api.recruitee.com/c/referbot/careers/offers')
  test1 = JSON.parse(receivelist, symbolize_names: true)
  contents = test1[:offers]
  list = ""
  contents.each_with_index do |content, index|
    list = list + "#{index+1}, #{content[:title]} \n #{content[:careers_url]} \n"
  end
  return list
end

def broadcast_to_general
  uri = URI("https://slack.com/api/channels.list?token=#{ENV['SLACK_API_TOKEN']}")

  # Needs reformatting with names to symbol
  uri_response = JSON.parse(Net::HTTP.get(uri))

  # Assuming #general is always the first item in the channels
  # array. Needs non-hard coded fix
  general_channel = uri_response["channels"][0]["id"]

  client.say(text: "Someone has just referred a friend to come join our company! What are your excuses, meatbags?", channel: general_channel)
end
