
# The order in which the scripts are required is also the order ruby excecutes them
require 'slack-ruby-bot'
require 'slack-ruby-client'
# require 'slack-referbot/commands/vacancylist'
# require 'slack-referbot/commands/referral'
# require 'slack-referbot/commands/phone'
# require 'slack-referbot/commands/email'
# require 'slack-referbot/commands/help'

#The bot class should be excecuted after all other scripts
require 'slack-referbot/bot'
