require 'spec_helper'

describe SlackReferbot::App do
  def app
    SlackReferbot::Bot.instance
  end
  it_behaves_like 'a slack ruby bot'
end
