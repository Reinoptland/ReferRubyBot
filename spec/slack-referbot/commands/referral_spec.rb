require 'spec_helper'

describe SlackReferbot::Commands::Referral do
  def app
    SlackReferbot::Bot.instance
  end
  it 'responds to the words Add (someone)' do
    expect(message: "#{SlackRubyBot.config.user} Add Bram", channel: 'channel').to respond_with_slack_message('What can I fill in as a first name?')
  end
end
