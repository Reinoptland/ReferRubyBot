require 'http'
require 'json'

module SlackReferbot
  module Commands
    class List < SlackRubyBot::Commands::Base
      command 'list' do |client, data, _match|

        offers = HTTP.get('https://api.recruitee.com/c/referbot/careers/offers')

        test1 = JSON.parse(offers, symbolize_names: true)
          contents = test1[:offers]
          contents.each do |content|
            client.say(channel: data.channel, text: "#{content[:id]}, #{content[:title]} \n #{content[:careers_url]} \n")
          end

        client.say(channel: data.channel, text: "")
      end
    end
  end
end
