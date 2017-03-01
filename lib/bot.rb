require './lib/formatter'
require './lib/guide_data'
require './lib/scraper'

# Bot functions
class Bot < SlackRubyBot::Bot
  def self.load_resources
    @editorial_guide = Scraper.get_page_content('http://www.bath.ac.uk/guides/editorial-style-guide/')
    @guide_urls = GuideData.define_guide_search_terms
  end

  # Search the editorial style guide for guidance
  match(/^style guide for (?<term>[\w\s\-\'’]*)$/) do |client, data, match|
    search_term = clean_user_input(match)

    client.say(text: "Looking for '#{search_term}'...", channel: data.channel)

    matches = Scraper.check_for_matches(@editorial_guide, search_term)

    if matches == false
      client.say(text: "Sorry, I couldn't find anything about '#{search_term}'", channel: data.channel)
    else
      client.say(text: matches, channel: data.channel)
    end
  end

  # Find relevant guide and give them the link
  match(/^rtm (?<term>[\w\s]*)$/) do |client, data, match|
    user_input = clean_user_input(match)

    # Work out the possible hash key, swapping spaces for underscores
    key = user_input.tr(' ', '_')

    # Get the link to the manual
    manual = @guide_urls[key.to_sym]

    # If the link exists, post it to Slack
    if manual.nil?
      client.say(text: "I don't know any guides about #{user_input}", channel: data.channel)
    else
      client.say(text: "Read this: http://www.bath.ac.uk/#{manual}", channel: data.channel)
    end
  end

  # Freak out if someone mentions bulleted lists
  match(/(bullet*e?d?\slist)/i) do |client, data|
    client.say(text: 'NOOOOOOOOOO', channel: data.channel)
  end

  def self.clean_user_input(match)
    [match[:term]][0].downcase.chomp
  end
end
