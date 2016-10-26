# editorial-bot

This bot provides links to editorial guidance on request.

## Getting it running

You must set the SLACK_API_TOKEN environment variable to run this locally. [Follow the slack-ruby-bot documentation](https://github.com/slack-ruby/slack-ruby-bot/blob/master/DEPLOYMENT.md) to register your bot and get the token. Make sure you have invited the bot to the channel as well.

Once you've done this, `cd` to this folder and run `bundle exec ruby bot.rb`.

## Features

### Says hi

Say hi to the bot. It will say hi back.

### Links to Guidance

Say "rtfm", followed by a keyword. The bot will try to find guidance that matches this keyword.

### Bulleted lists

If someone in the channel tries to bring up bulleted lists, the bot will react appropriately.