# Apply formatting for Slack
class Formatting
  # Check and apply formatting
  def self.format_for_slack(element)
    if element.name =~ /h[1-6]/
      format_headers(element)
    elsif element.name == 'ul'
      format_unordered_lists(element)
    elsif element.name == 'ol'
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
      next unless list_item.name == 'li'
      list_items << "- #{list_item.content.chomp}"
    end
    list_items.join("\n>")
  end

  # For ordered lists, add numbers before each list item
  def self.format_ordered_lists(element)
    list_items = []
    n = 1
    element.children.each do |list_item|
      next unless list_item.name == 'li'
      list_items << "#{n}. #{list_item.content.chomp}"
      n += 1
    end
    list_items.join("\n>")
  end
end
