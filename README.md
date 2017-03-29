# editorial-bot

[![Travis build](https://travis-ci.org/uniofbathdmc/editorial-bot.svg?branch=master)](https://travis-ci.org/uniofbathdmc/editorial-bot)
[![Security](https://hakiri.io/github/uniofbathdmc/editorial-bot/master.svg)](https://hakiri.io/github/uniofbathdmc/editorial-bot/master) [![Code Climate](https://codeclimate.com/github/uniofbathdmc/editorial-bot/badges/gpa.svg)](https://codeclimate.com/github/uniofbathdmc/editorial-bot) [![Test coverage](https://codeclimate.com/github/uniofbathdmc/editorial-bot/badges/coverage.svg)](https://codeclimate.com/github/uniofbathdmc/editorial-bot/coverage)

This bot provides editorial guidance on request. The guidance is based on the University of Bath's digital style guides.

## Getting it running

Clone this repo and run `bundle install`.

[Follow the slack-ruby-bot documentation](https://github.com/slack-ruby/slack-ruby-bot/blob/master/DEPLOYMENT.md) to create and register your bot and get an API token.

Invite the bot to a channel.

To start the bot:

1. Set the SLACK_API_TOKEN environment variable
2. `cd` to the folder where the bot is
3. Run `bundle exec ruby editorial-bot.rb`

## Features

### Says hi

Say hi to the bot.

> @editorial-bot hi

It will say hi back.

### Links to guidance

Say 'rtm', followed by a keyword.

> rtm images

The bot will try to find guidance that matches this keyword and post a link to it.

### Editorial style guide

Say 'style guide for', followed by a keyword.

> style guide for dates

The bot will check the editorial style guide for relevant guidance and post it to the channel.

### Bulleted lists

If someone in the channel tries to bring up bulleted lists, the bot will react appropriately to avert any debate.

## License

This project is licensed under an Apache 2.0 license. See the [LICENSE](LICENSE) file for details.