$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'dotenv'
Dotenv.load

require 'slack-referbot'
require 'web'
require 'net/http'
require 'http'
require 'json'
require 'redis'

Thread.abort_on_exception = true

Thread.new do
  begin
    SlackReferbot::Bot.run
  rescue Exception => e
    STDERR.puts "ERROR: #{e}"
    STDERR.puts e.backtrace
    raise e
  end
end

run SlackReferbot::Web
