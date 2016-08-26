module SlackReferbot
  module Commands
    class Vacancylist < SlackRubyBot::Commands::Base
      command 'list' do |client, data, _match|

      contents = fetchlist
      contents = contents.sort_by { |vacancy| vacancy[:created_at] }
      content = contents.first
      latest_vacancy_date = Date.parse content[:created_at]
      latest_vacancy_date = latest_vacancy_date.to_s
      today = Time.now.strftime("%Y-%d-%m")

      client.say(text: "#{display(contents)}", channel: data.channel)

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


def fetchlist
  receivelist = HTTP.get('https://api.recruitee.com/c/referbot/careers/offers')
  # receivelist = HTTParty.get('https://api.recruitee.com/c/levelupventures/careers/offers').to_json
  test1 = JSON.parse(receivelist, symbolize_names: true)
  test1[:offers]
end

def display(contents)
  list = ""
  contents.each_with_index do |content, index|
    list = list + "#{index+1}, #{content[:title]} \n #{content[:careers_url]} \n"
  end
  return list
end
