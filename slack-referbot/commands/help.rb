module SlackReferbot
  module Commands
    class Referral < SlackRubyBot::Commands::Base

      command 'help' do |client, data, match|
        # identifier = match['expression']

          $workaround = ""
        #displayed help text
        client.say(text: 'Welcome to my help function!', channel: data.channel)
        client.say(text: "Its my function to acquire contact details of potential new colleges.", channel: data.channel)
        client.say(text: "Type list - show list of open vacanties", channel: data.channel)
        client.say(text: "Type add - to make a new referal.", channel: data.channel)
        client.say(text: "Type phone - add phone number",  channel: data.channel)
        client.say(text: "Type email - add email adress", channel: data.channel)

      end
    end #ends class
  end #ends module commands
end #ends module SlackReferbot
