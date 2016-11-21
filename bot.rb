require 'slack-ruby-bot'
require 'nokogiri'
require 'open-uri'
require 'uri'

class Bot < SlackRubyBot::Bot
  # Try to scrape the editorial guide
  match(/^style guide for (?<topic>[\w\s\-\'’]*)$/) do |client, data, match|
    # Get the search term in lowercase
    search_term = [match[:topic]][0].downcase.chomp

    # Open the page in Nokogiri
    html = open('http://www.bath.ac.uk/guides/editorial-style-guide/')
    doc = Nokogiri::HTML(html)

    found_something = false

    client.say(text: "Looking for '#{search_term}'...", channel: data.channel)

    # Check each heading to see if it matches the search term
    doc.css('h1,h2,h3,h4,h5,h6').each do |heading_tag|
      heading = heading_tag.text.downcase.chomp

      # Skip this heading unless it matches the search term
      next unless heading.include?(search_term)

      # Check what level this heading is so we know when to stop
      heading_level = heading_tag.to_s[2].to_i

      relevant_content = []
      element = heading_tag.next_element

      # Process the text of all the next elements until one of the following happens:
      # - the next element is a header of equivalent or higher level
      # - the next element does not exist and the section is over
      until (element.to_s =~ /^<h[0-#{heading_level}]/) || element.nil?
        content = element.text

        # If it's a heading, add asterisks
        content = "*#{content}*" if element.to_s =~ /^<h/

        # If it's an unordered list, add hyphens before each list item
        if element.to_s =~ /^<ul/
          list_items = []
          element.children.each do |list_item|
            next unless list_item.to_s =~ /^<li/
            list_items << "- #{list_item.content.chomp}"
          end
          content = list_items.join("\n>")
        end

        # If it's an ordered list, add numbers before each list item
        if element.to_s =~ /^<ol/
          list_items = []
          n = 1
          element.children.each do |list_item|
            next unless list_item.to_s =~ /^<li/
            list_items << "#{n}. #{list_item.content.chomp}"
            n += 1
          end
          content = list_items.join("\n>")
        end

        # Add the content
        relevant_content << "> #{content}"

        # Move on to the next element
        element = element.next_element
      end

      output = relevant_content.join("\n>\n")

      client.say(text: "*Style guide for #{heading}*:\n\n#{output}", channel: data.channel)

      # Get out of this loop to avoid onslaught of text
      found_something = true
      break
    end

    # If we didn't find anything, notify the user
    client.say(text: "Sorry, I couldn't find anything about '#{search_term}'", channel: data.channel) if found_something == false
  end

  # Find relevant guide and give them the link
  match(/^rtm (?<topic>[\w\s]*)$/) do |client, data, match|
    # Get the user input
    user_input = [match[:topic]][0]
    # Work out the possible hash key, swapping spaces for underscores
    key = user_input.tr(' ', '_')
    # Get the link to the manual
    manual = @guides[key.to_sym]
    # If the link exists, post it to Slack
    if manual.nil?
      client.say(text: "I don't know any guides about #{user_input}", channel: data.channel)
    else
      client.say(text: "Read this: http://www.bath.ac.uk/#{manual}", channel: data.channel)
    end
  end

  # Freak out if someone mentions bulleted lists
  match(/([Bb][Uu][Ll][Ll][Ee][Tt]*[Ee]*[Dd]*\s[Ll][Ii][Ss][Tt])/) do |client, data|
    client.say(text: 'NOOOOOOOOOO', channel: data.channel)
  end

  # Data time
  def self.define_urls
    @urls = {
      announcement: 'guides/creating-an-announcement/',
      campaign: 'guides/creating-a-campaign',
      case_study: '/guides/creating-a-case-study/',
      corporate_information: 'guides/creating-a-corporate-information-page/',
      editorial_style_guide: 'guides/editorial-style-guide/',
      event: 'guides/creating-an-event-page/',
      formatting: 'guides/formatting-text-in-the-content-publisher/',
      guide: 'guides/creating-a-guide/',
      image_style_guide: 'guides/using-images-on-the-website/',
      landing_page: 'guides/creating-a-landing-page/',
      location: 'guides/creating-a-location-page/',
      person_profile: 'guides/creating-a-person-profile/',
      project: 'guides/creating-a-project-page/',
      publication: 'guides/creating-a-publication-page/',
      service_start: 'guides/creating-a-service-start/',
      team_profile: 'guides/creating-a-team-profile/'
    }
  end

  def self.define_guides
    # First get all the URLs
    define_urls

    # Match the search term to the right URL
    @guides = {
      announcement: @urls[:announcement],
      campaign: @urls[:campaign],
      case_study: @urls[:case_study],
      corporate: @urls[:corporate_information],
      corporate_information: @urls[:corporate_information],
      corp_info: @urls[:corporate_information],
      corporate_info: @urls[:corporate_information],
      editorial: @urls[:editorial_style_guide],
      editorial_style_guide: @urls[:editorial_style_guide],
      event: @urls[:event],
      formatting: @urls[:formatting],
      group: @urls[:landing_page],
      guide: @urls[:guide],
      images: @urls[:image_style_guide],
      landing_page: @urls[:landing_page],
      location: @urls[:location],
      markdown: @urls[:formatting],
      org: @urls[:landing_page],
      organisation: @urls[:landing_page],
      person: @urls[:person_profile],
      person_profile: @urls[:person_profile],
      project: @urls[:project],
      publication: @urls[:publication],
      service: @urls[:service_start],
      service_start: @urls[:service_start],
      style_guide: @urls[:editorial_style_guide],
      team: @urls[:team_profile],
      team_profile: @urls[:team_profile]
    }
  end
end

# Starting up
Bot.define_guides
Bot.run
