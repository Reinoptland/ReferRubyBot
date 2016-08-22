require 'spec_helper'

describe SlackMathbot::App do
  def app
    SlackMathbot::Bot.instance
  end
  it_behaves_like 'a slack ruby bot'
end
