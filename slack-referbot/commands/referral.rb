module SlackReferbot
  module Commands
    class Referral < SlackRubyBot::Commands::Base
      command 'add' do |client, data, match|
        if $workaround == nil
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

                    vacancies = get_vacancy_list
                    vacancies_order_by_latest = vacancies_order_by_latest(vacancies)
                    client.say(text: "#{display_all_vacancies_indexed(vacancies_order_by_latest)}", channel: data.channel)

                    client.say(text: "Which vacancy would your candidate be best for?", channel: data.channel)

                    $workaround =""
                    client.on :message do |answer|
                      client.instance_variable_get(:@callbacks)['message'].pop
                      referral[:vacancy_number] = (answer.text.to_i - 1)


                      client.say(text: "Thank you! I have added `#{identifier}` to the registry \n For the position of: #{vacancies_order_by_latest[referral[:vacancy_number]][:title]} \n Thanks for helping me conquer the worl.. \n I mean thanks for referring this awesome person", channel: data.channel)
                      $workaround =""
                      Redis.current.mapped_hmset(identifier, referral)

                      uri = URI("https://slack.com/api/channels.list?token=#{ENV['SLACK_API_TOKEN']}")

                      # Needs reformatting with names to symbol
                      uri_response = JSON.parse(Net::HTTP.get(uri))

                      # Assuming #general is always the first item in the channels
                      # array. Needs non-hard coded fix
                      general_channel = uri_response["channels"][0]["id"]

                      client.say(text: "<@#{data.user}> has just referred a friend to come join our company! What are your excuses, meatbags?", channel: general_channel)
                      $workaround = nil
                    end
                  end
                end
              end
            end
          end
        end
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
