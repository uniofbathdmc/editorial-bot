require 'slack-ruby-bot'

class Bot < SlackRubyBot::Bot
  # Freak out if someone mentions bulleted lists
  match /([Bb][Uu][Ll][Ll][Ee][Tt]*[Ee]*[Dd]*\s[Ll][Ii][Ss][Tt])/ do |client, data, match|
    client.say(text: 'NOOOOOOOOOO', channel: data.channel)
  end

  # Find relevant guide and give them the link
  match /^rtfm (?<topic>[\w\s]*)$/ do |client, data, match|
    # Get the user input
    user_input = [match[:topic]][0]
    # Work out the possible hash key, swapping spaces for underscores
    key = user_input.gsub(' ','_')
    # Get the link to the manual
    manual = @guides[key.to_sym]
    # If the link exists, post it to Slack
    if manual.nil?
      client.say(text: "I don't know any guides about #{user_input}", channel: data.channel)
    else
    	client.say(text: "Read this: http://www.bath.ac.uk/#{manual}", channel: data.channel)
    end
  end

  # Data time
  def self.define_urls
    @urls = {
      announcement: "guides/creating-an-announcement/",
      campaign: "guides/creating-a-campaign",
      case_study: "/guides/creating-a-case-study/",
      corporate_information: "guides/creating-a-corporate-information-page/",
      editorial_style_guide: "guides/editorial-style-guide/",
      event: "guides/creating-an-event-page/",
      formatting: "guides/formatting-text-in-the-content-publisher/",
      guide: "guides/creating-a-guide/",
      image_style_guide: "guides/using-images-on-the-website/",
      landing_page: "guides/creating-a-landing-page/",
      location: "guides/creating-a-location-page/",
      person_profile: "guides/creating-a-person-profile/",
      project: "guides/creating-a-project-page/",
      publication: "guides/creating-a-publication-page/",
      service_start: "guides/creating-a-service-start/",
      team_profile: "guides/creating-a-team-profile/"
    }
  end

  def self.define_guides
    # First get all the URLs
    self.define_urls

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
