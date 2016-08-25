module SlackReferbot
  module Commands
    class Referral < SlackRubyBot::Commands::Base

      #this script needs to run on every command except "add", "refer", "whois"
      operator 'asd' do |client, data, match|

        client.on :message do |answer|

            unless !answer.text.match(/phone|add|help/i)
              client.instance_variable_get(:@callbacks)['message'].pop
              client.say(text: "working!", channel: data.channel)
            end
          end
        end
      end #class
    end #Module Commands
  end #Module SlackReferbot
