module SlackReferbot
  module Commands
    class Referral < SlackRubyBot::Commands::Base
      command 'add' do |client, data, match|
        identifier = match['expression']
        referral = {}

        $workaround = ""

          client.say(text: 'What can I fill in as a first name?', channel: data.channel)
          client.on :message do |answer|
          if !answer.text.match(/^add /i)
            client.instance_variable_get(:@callbacks)['message'].pop
            referral[:first_name] = answer.text


            client.say(text: 'Can you also give me the last name?', channel: data.channel)
            client.on :message do |answer|
              client.instance_variable_get(:@callbacks)['message'].pop
              referral[:last_name] = answer.text

              client.say(text: "How about a phonenumber?", channel: data.channel)
              $workaround = ""
              client.on :message do |answer|
                client.instance_variable_get(:@callbacks)['message'].pop
                referral[:phone_number] = answer.text.to_i


                client.say(text: "Can we get an e-mail maybe?", channel: data.channel)
                $workaround = ""
                client.on :message do |answer|
                  client.instance_variable_get(:@callbacks)['message'].pop
                  referral[:email] = answer.text


                  offers = HTTP.get('https://api.recruitee.com/c/referbot/careers/offers')
                  test1 = JSON.parse(offers, symbolize_names: true)
                    contents = test1[:offers]
                    contents.each_with_index do |content, index|
                      client.say(channel: data.channel, text: "#{index + 1}, #{content[:title]} \n #{content[:careers_url]} \n")
                    end

                    client.say(text: "Which vacancy would your candidate be best for?", channel: data.channel)
                    $workaround = ""
                    client.on :message do |answer|
                      client.instance_variable_get(:@callbacks)['message'].pop
                      referral[:vacancy_number] = answer.text

                  client.say(text: "Thank you! I have added `#{identifier}` to the registry.", channel: data.channel)
                  Redis.current.mapped_hmset(identifier, referral)
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
