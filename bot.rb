require 'slack-ruby-bot'
require 'nokogiri'
require 'open-uri'
require 'uri'

class Bot < SlackRubyBot::Bot
  # Try to scrape the editorial guide
  match(/^style guide for (?<term>[\w\s\-\'’]*)$/) do |client, data, match|
    search_term = clean_user_input(match)

    client.say(text: "Looking for '#{search_term}'...", channel: data.channel)

    # Open the page in Nokogiri
    html = open('http://www.bath.ac.uk/guides/editorial-style-guide/')
    doc = Nokogiri::HTML(html)

    matches = false

    # Check each heading to see if it matches the search term
    doc.css('h1,h2,h3,h4,h5,h6').each do |heading_tag|
      heading = heading_tag.text.downcase.chomp

      next unless heading.include?(search_term)

      output = Scraper.process_sections(heading_tag)

      client.say(text: "*Style guide for #{heading}*:\n\n#{output}", channel: data.channel)

      # Get out of this loop to avoid onslaught of text
      matches = true
      break
    end

    # matches = Scraper.check_for_matches(doc)

    # If we didn't find anything, notify the user
    client.say(text: "Sorry, I couldn't find anything about '#{search_term}'", channel: data.channel) if matches == false
  end

  # Find relevant guide and give them the link
  match(/^rtm (?<term>[\w\s]*)$/) do |client, data, match|
    guide_urls = GuideData.define_guides

    user_input = clean_user_input(match)

    # Work out the possible hash key, swapping spaces for underscores
    key = user_input.tr(' ', '_')

    # Get the link to the manual
    manual = guide_urls[key.to_sym]

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

# Scraping HTML
class Scraper
  def self.check_for_matches(doc)
    found_something = false

    # Check each heading to see if it matches the search term
    doc.css('h1,h2,h3,h4,h5,h6').each do |heading_tag|
      heading = heading_tag.text.downcase.chomp

      next unless heading.include?(search_term)

      output = Scraper.process_sections(heading_tag)

      client.say(text: "*Style guide for #{heading}*:\n\n#{output}", channel: data.channel)

      # Get out of this loop to avoid onslaught of text
      found_something = true
      break
    end

    found_something
  end

  def self.find_heading_level(heading_tag)
    heading_tag.to_s[2].to_i
  end

  def self.process_sections(heading_tag)
    # Check what level this heading is so we know when to stop
    heading_level = Scraper.find_heading_level(heading_tag)

    relevant_content = []
    element = heading_tag.next_element

    # Process the text of all the next elements until either
    # the next element is a header of equivalent or higher level
    # or the next element does not exist and the section is over
    until (element.to_s =~ /^<h[0-#{heading_level}]/) || element.nil?
      content = Formatting.format_for_slack(element)

      # Add the content
      relevant_content << "> #{content}"

      # Move on to the next element
      element = element.next_element
    end
    relevant_content.join("\n>\n")
  end
end

# Set up the data for finding guides
class GuideData
  def self.define_urls
    {
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
    urls = define_urls

    # Match the search term to the right URL
    {
      announcement: urls[:announcement],
      campaign: urls[:campaign],
      case_study: urls[:case_study],
      corporate: urls[:corporate_information],
      corporate_information: urls[:corporate_information],
      corp_info: urls[:corporate_information],
      corporate_info: urls[:corporate_information],
      editorial: urls[:editorial_style_guide],
      editorial_style_guide: urls[:editorial_style_guide],
      event: urls[:event],
      formatting: urls[:formatting],
      group: urls[:landing_page],
      guide: urls[:guide],
      images: urls[:image_style_guide],
      landing_page: urls[:landing_page],
      location: urls[:location],
      markdown: urls[:formatting],
      org: urls[:landing_page],
      organisation: urls[:landing_page],
      person: urls[:person_profile],
      person_profile: urls[:person_profile],
      project: urls[:project],
      publication: urls[:publication],
      service: urls[:service_start],
      service_start: urls[:service_start],
      style_guide: urls[:editorial_style_guide],
      team: urls[:team_profile],
      team_profile: urls[:team_profile]
    }
  end
end

# Apply formatting for Slack
class Formatting
  # Check and apply formatting
  def self.format_for_slack(element)
    if element.to_s =~ /^<h/
      format_headers(element)
    elsif element.to_s =~ /^<ul/
      format_unordered_lists(element)
    elsif element.to_s =~ /^<ol/
      format_ordered_lists(element)
    else
      element.text
    end
  end

  # Add bold to headers
  def self.format_headers(element)
    "*#{element.text}*"
  end

  # For unordered lists, add hyphens before each list item
  def self.format_unordered_lists(element)
    list_items = []
    element.children.each do |list_item|
      next unless list_item.to_s =~ /^<li/
      list_items << "- #{list_item.content.chomp}"
    end
    list_items.join("\n>")
  end

  # For ordered lists, add numbers before each list item
  def self.format_ordered_lists(element)
    list_items = []
    n = 1
    element.children.each do |list_item|
      next unless list_item.to_s =~ /^<li/
      list_items << "#{n}. #{list_item.content.chomp}"
      n += 1
    end
    list_items.join("\n>")
  end
end

Bot.run
