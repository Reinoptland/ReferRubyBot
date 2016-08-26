module SlackReferbot
  class Bot < SlackRubyBot::Bot
    ref = Referee.new
    sc = SlackConnection.new

    operator '' do |client, data, match|
      # User types refer
      if /(^refer| refer)/i.match(data.text) && ref.states[:in_conversation] == false

        dm_channel = sc.get_dm_channel(data)

        client.say(channel: dm_channel, text: "Hi <@#{data.user}>. Would you like to refer someone to one of our open vacancies?")

        ref.states[:in_conversation] = true
        data.text = ''

      end

      # User is asked to confirm to start referring process
      if /^y/i.match(data.text) && ref.states[:in_conversation]

        client.say(channel: data.channel, text: "Excellent, let's get started!")
        sleep(0.5)
        client.say(channel: data.channel, text: "What is your referee's name?")

        ref.states[:get_name] = true
        data.text = ''

      elsif /^n/i.match(data.text) && ref.states[:in_conversation]
        client.say(channel: data.channel, text: "My bad!")
        sleep(0.5)
        client.say(channel: data.channel, text: "Feel free to contact me any time you want to refer someone to our company!")

        ref.states[:in_conversation] = false

      elsif !/(^y|^n)/i.match(data.text) && data.text != '' && ref.states[:in_conversation] && ref.states[:get_name] == false
        client.say(channel: data.channel, text: "I didn't quite get that... Do you want to refer someone?")

        data.text = ''

      end

      # User is asked to provide a name...
      if data.text != '' && ref.states[:get_name] && !ref.states[:get_email]
        ref.attributes[:name] = data.text
        client.say(channel: data.channel, text: "#{ref.attributes[:name]}, what a lovely name!")

        client.say(channel: data.channel, text: "We will have to contact #{ref.attributes[:name]} as well... Do you have an e-mail address?")

        ref.states[:get_email] = true
        data.text = ''

      end

      # ... email...
      if data.text != '' && ref.states[:get_email] && !ref.states[:get_vacancy]
        ref.attributes[:email] = data.text

        ref.reformat_email

        client.say(channel: data.channel, text: "Great! Let me show you a list of vacancies that we are looking to fill.")

        list = getlist
        client.say(text: "#{list}", channel: data.channel)

        client.say(channel: data.channel, text: "Please enter the vacancy that you would like to recommend #{ref.attributes[:name]} for. If you think an open application would be more appropriate, just type 0!")

        ref.states[:get_vacancy] = true
        data.text = ''
      end

      # ... vacancy...
      if data.text != '' && ref.states[:get_vacancy] && !ref.states[:input_gathered]
        ref.attributes[:vacancy] = data.text

        ref.states[:input_gathered] = true
        data.text = ''
      end

      # Display result
      if ref.states[:input_gathered]
        client.say(channel: data.channel, text: "Awesome! You have finished referring #{ref.attributes[:name]} for the job of #{ref. attributes[:vacancy]}. We'll initiate contact at #{ref.attributes[:email]} as soon as possible!")

        ref.states[:in_conversation] = false
        ref.states[:get_name] = false
        ref.states[:get_email] = false
        ref.states[:get_vacancy] = false
        ref.states[:input_gathered] = false

        sc.broadcast_to_general("<@#{data.user}> has just referred a friend to come join our company!", client)
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
