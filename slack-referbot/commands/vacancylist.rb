module SlackReferbot
  module Commands
    class Vacancylist < SlackRubyBot::Commands::Base
      command 'list' do |client, data, _match|

      vacancies = get_vacancy_list
      vacancies_order_by_latest = vacancies.sort_by { |vacancy| vacancy[:created_at] }
      latest_vacancy = vacancies_order_by_latest.first
      latest_vacancy_date = Date.parse latest_vacancy[:created_at]
      latest_vacancy_date_string_format = latest_vacancy_date.to_s
      date_today = Time.now.strftime("%Y-%d-%m")

      client.say(text: "#{display_all_vacancies_indexed(vacancies_order_by_latest)}", channel: data.channel)

      client.say(channel: data.channel, text: " #{latest_vacancy[:title]} \n #{latest_vacancy[:careers_url]} \n #{Time.now.strftime("at %I:%M%p")} \n #{date_today} \n #{} ")

        if date_today === latest_vacancy_date_string_format
        client.say(channel: data.channel, text: "oink")
        else
        client.say(channel: data.channel, text: "boo!")
        end
      end
    end
  end
end


def get_vacancy_list
  recruitee_vacancy_list = HTTP.get('https://api.recruitee.com/c/referbot/careers/offers')
  # receivelist = HTTParty.get('https://api.recruitee.com/c/levelupventures/careers/offers').to_json
  vacancies = JSON.parse(recruitee_vacancy_list, symbolize_names: true)
  vacancies[:offers]
end

def display_all_vacancies_indexed(vacancies_order_by_latest)
  display_list = ""
  vacancies_order_by_latest.each_with_index do |vacancy, index|
    display_list = display_list + "#{index+1}, #{vacancy[:title]} \n #{vacancy[:careers_url]} \n"
  end
  return display_list
end
