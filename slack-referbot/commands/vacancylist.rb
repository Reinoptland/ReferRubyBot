module SlackReferbot
  module Commands
    class Vacancylist < SlackRubyBot::Commands::Base
      command 'list' do |client, data, _match|



        offers = HTTP.get('https://api.recruitee.com/c/referbot/careers/offers')

        test1 = JSON.parse(offers, symbolize_names: true)
          contents = test1[:offers]
          contents = contents.sort_by { |vacancy| vacancy[:created_at] }
          content = contents.first
          client.say(channel: data.channel, text: " #{content[:title]} \n #{content[:careers_url]}")

        client.say(channel: data.channel, text: "")
      end
    end
  end
end
