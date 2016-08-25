module SlackReferbot
  module Commands
    class Referral < SlackRubyBot::Commands::Base

      command 'help' do |client, data, match|

        $workaround =""

        help_texts = [
          'Welcome to my help function!',
          "Its my function to acquire contact details of potential new colleges.",
          "Type add - to make a new referal.",
          "List - show list of open vacanties",
        ]
        #displayed help text
        help_texts.each do |text|
          client.say(text: text, channel: data.channel)
        end
      end
    end #ends class
  end #ends module commands
end #ends module SlackReferbot
