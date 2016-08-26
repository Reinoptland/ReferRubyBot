module SlackReferbot
  module Commands
    class Vacancylist < SlackRubyBot::Commands::Base
      command 'last' do |client, data, _match|

      vacancies = get_vacancy_list
      vacancies_order_by_latest = vacancies_order_by_latest(vacancies)
      latest_vacancy = vacancies_order_by_latest.first

      # format date for latest vacancy and today so they can be compared
      latest_vacancy_date = Date.parse latest_vacancy[:created_at]
      latest_vacancy_date_string_format = latest_vacancy_date.to_s
      date_today = Time.now.strftime("%Y-%d-%m")

      client.say(channel: data.channel, text: "The lastest vacancy is: \n #{latest_vacancy[:title]} \n #{latest_vacancy[:careers_url]} \n This vacancy was posted on: #{latest_vacancy_date}  ")

        if date_today === latest_vacancy_date_string_format
        client.say(channel: data.channel, text: "That's today!")
        else
        client.say(channel: data.channel, text: "That's many days ago actually")
        end

      client.say(channel: data.channel, text: "Hey! If you know a guy just type \"refer\" ")

      end
    end
  end
end
