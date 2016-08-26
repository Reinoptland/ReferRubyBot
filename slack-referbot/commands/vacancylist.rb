module SlackReferbot
  module Commands
    class Vacancylist < SlackRubyBot::Commands::Base
      command 'list' do |client, data, _match|

      vacancies = get_vacancy_list
      vacancies_order_by_latest = vacancies_order_by_latest(vacancies)

      client.say(text: "#{display_all_vacancies_indexed(vacancies_order_by_latest)}", channel: data.channel)
      client.say(channel: data.channel, text: "Hey! If you know a guy just type \"refer\" (and possibly get 1000 euros!)")
      end
    end
  end
end



def get_vacancy_list
  recruitee_vacancy_list = HTTP.get('https://api.recruitee.com/c/referbot/careers/offers')
  vacancies = JSON.parse(recruitee_vacancy_list, symbolize_names: true)
  vacancies[:offers]
end

def vacancies_order_by_latest(vacancies)
  vacancies_order_by_latest = vacancies.sort_by { |vacancy| vacancy[:created_at] }
end

def display_all_vacancies_indexed(vacancies_order_by_latest)
  display_list = ""
  vacancies_order_by_latest.each_with_index do |vacancy, index|
    display_list = display_list + "#{index+1}, #{vacancy[:title]} \n #{vacancy[:careers_url]} \n"
  end
  return display_list
end
