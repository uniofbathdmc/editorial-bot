require 'nokogiri'
require 'open-uri'
require 'uri'

# Scraping HTML
class Scraper
  def self.get_page_content(url)
    html = open(url)
    Nokogiri::HTML(html)
  end

  def self.check_for_matches(page, search_term)
    page.css('h1,h2,h3,h4,h5,h6').each do |heading_tag|
      heading = heading_tag.text.downcase.chomp

      if heading.include?(search_term)
        output = process_sections(heading_tag)
        return "*Style guide for #{heading}*:\n\n#{output}"
      end
    end

    false
  end

  def self.find_heading_level(heading_tag)
    heading_tag.name[1].to_i
  end

  def self.process_sections(heading_tag)
    # Check what level this heading is so we know when to stop
    heading_level = Scraper.find_heading_level(heading_tag)

    relevant_content = []
    element = heading_tag.next_element

    # Process the text of all the next elements until the next element does not exist and the section is over
    # or the next element is a header of equivalent or higher level
    until element.nil? || element.name[1].to_i.between?(1, heading_level)
      content = Formatting.format_for_slack(element)

      # Add the content
      relevant_content << "> #{content}"

      # Move on to the next element
      element = element.next_element
    end
    relevant_content.join("\n>\n")
  end
end
