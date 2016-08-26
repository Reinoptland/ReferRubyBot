module SlackReferbot
  module Commands
    class Vacancylist < SlackRubyBot::Commands::Base
      command 'list' do |client, data, _match|

      offers = HTTP.get('https://api.recruitee.com/c/referbot/careers/offers')

      test1 = JSON.parse(offers, symbolize_names: true)
      contents = test1[:offers]
      contents = contents.sort_by { |vacancy| vacancy[:created_at] }
      content = contents.first
      latest_vacancy_date = Date.parse content[:created_at]
      latest_vacancy_date = latest_vacancy_date.to_s
      today = Time.now.strftime("%Y-%d-%m")



      client.say(channel: data.channel, text: " #{content[:title]} \n #{content[:careers_url]} \n #{Time.now.strftime("at %I:%M%p")} \n #{today} \n #{} ")

        if today === latest_vacancy_date
        client.say(channel: data.channel, text: "oink")
        else
        client.say(channel: data.channel, text: "boo!")
        end
      end
    end
  end
end
