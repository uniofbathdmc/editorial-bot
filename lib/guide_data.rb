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

  def self.define_guide_search_terms
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
