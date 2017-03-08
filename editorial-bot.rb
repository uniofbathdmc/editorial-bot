require 'slack-ruby-bot'
require './lib/bot'

# Don't log everything by default. Comment this line out for debugging
SlackRubyBot::Client.logger.level = Logger::WARN

# Start the bot
Bot.load_resources
Bot.run
