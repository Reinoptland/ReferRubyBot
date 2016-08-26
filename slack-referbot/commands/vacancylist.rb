module SlackReferbot
  module Commands
    class Vacancylist < SlackRubyBot::Commands::Base
      command 'list' do |client, data, _match|



        offers = HTTP.get('https://api.recruitee.com/c/referbot/careers/offers')

        test1 = JSON.parse(offers, symbolize_names: true)
          contents = test1[:offers]
          contents = contents.sort_by { |vacancy| vacancy[:created_at] }
          contents.each_with_index do |content, index|
            client.say(channel: data.channel, text: "#{index + 1}, #{content[:title]} \n #{content[:careers_url]} \n #{content[:created_at]}\n")
          end

        client.say(channel: data.channel, text: "")
      end
    end
  end
end
