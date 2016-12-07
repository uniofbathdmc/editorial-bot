# editorial-bot

This bot provides editorial guidance on request. The guidance is based on the University of Bath's digital style guides.

## Getting it running

Clone this repo and run `bundle install`.

[Follow the slack-ruby-bot documentation](https://github.com/slack-ruby/slack-ruby-bot/blob/master/DEPLOYMENT.md) to create and register your bot and get an API token.

Invite the bot to a channel.

To start the bot:

1. Set the SLACK_API_TOKEN environment variable
2. `cd` to the folder where the bot is
3. Run `bundle exec ruby bot.rb`

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