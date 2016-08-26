module SlackReferbot
  module Commands
    class Referral < SlackRubyBot::Commands::Base
      command 'add' do |client, data, match|
        identifier = match['expression']
        referral = {}

          client.say(text: 'What can I fill in as a first name?', channel: data.channel)
          $workaround =""

          client.on :message do |answer|
          if !answer.text.match(/^add /i)
            client.instance_variable_get(:@callbacks)['message'].pop
            referral[:first_name] = answer.text

            client.say(text: 'Can you also give me the last name?', channel: data.channel)
            $workaround =""

            client.on :message do |answer|
              client.instance_variable_get(:@callbacks)['message'].pop
              referral[:last_name] = answer.text



              client.say(text: "Can we get an e-mail maybe?", channel: data.channel)

              $workaround =""
              client.on :message do |answer|

                client.instance_variable_get(:@callbacks)['message'].pop

                email_slack_formatted = answer.text

                # Test if Slack reformatted the string containing the referee's e-mail (it will contain '|'). If so reformat, if not, let it be.
                if /\|/.match(email_slack_formatted)
                  referral[:email] = email_slack_formatted.split('|')[1].chomp('>')
                else
                  referral[:email] = answer.text
                end

                client.say(text: "How about a phonenumber?", channel: data.channel)

                $workaround =""
                client.on :message do |answer|
                  client.instance_variable_get(:@callbacks)['message'].pop
                  referral[:phone_number] = answer.text.to_i

                  list = getlist
                  client.say(text: "#{list}", channel: data.channel)

                  client.say(text: "Which vacancy would your candidate be best for?", channel: data.channel)

                  $workaround =""
                  client.on :message do |answer|
                    client.instance_variable_get(:@callbacks)['message'].pop
                    referral[:vacancy_number] = answer.text


                    client.say(text: "Thank you! I have added `#{identifier}` to the registry.", channel: data.channel)
                    $workaround =""
                    Redis.current.mapped_hmset(identifier, referral)

                    uri = URI("https://slack.com/api/channels.list?token=#{ENV['SLACK_API_TOKEN']}")

                    # Needs reformatting with names to symbol
                    uri_response = JSON.parse(Net::HTTP.get(uri))

                    # Assuming #general is always the first item in the channels
                    # array. Needs non-hard coded fix
                    general_channel = uri_response["channels"][0]["id"]

                    client.say(text: "<@#{data.user}> has just referred a friend to come join our company! What are your excuses, meatbags?", channel: general_channel)
                  end
                end
              end
            end
          end
        end

        # client.say(text: 'I also want to know the email adress.', channel: data.channel)
        # client.on :message do |answer|
        #   referral[:email] = answer.text
        # end
        # client.say(text: 'Which phone number may I register?', channel: data.channel)
        # client.on :message do |answer|
        #   referral[:phone] = answer.text
        # end
        # client.say(text: 'Which vacancy can I sign up our candidate for?', channel: data.channel)
        # client.on :message do |answer|
        #   referral[:vacancy] = answer.text
        # end
      end

      command 'whois' do |client, data, match|
        identifier = match['expression']
        redis = Redis.current

        if redis.exists(identifier)
          referral = redis.hgetall(identifier)
          client.say(text: referral.inspect, channel: data.channel)
        else
          client.say(text: "Sorry but I can't find `#{identifier}` in the registry.", channel: data.channel)
        end
      end
    end
  end
end

def getlist
  receivelist = HTTP.get('https://api.recruitee.com/c/referbot/careers/offers')
  # receivelist = HTTParty.get('https://api.recruitee.com/c/levelupventures/careers/offers').to_json
  test1 = JSON.parse(receivelist, symbolize_names: true)
  contents = test1[:offers]
  list = ""
  contents.each_with_index do |content, index|
    list = list + "#{index+1}, #{content[:title]} \n #{content[:careers_url]} \n"
  end
  return list
end
