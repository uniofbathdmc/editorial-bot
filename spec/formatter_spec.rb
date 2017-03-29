require './lib/formatter'
require 'nokogiri'

describe Formatter do
  let(:code_with_everything) do
    example_code = '<h1>This is a heading</h1>'\
                   '<p>A paragraph <a href="url">with a link</a>.</p>'\
                   '<ul>'\
                   '<li>Eggs</li>'\
                   '<li>Milk</li>'\
                   '</ul>'\
                   '<ol>'\
                   '<li>Open the door</li>'\
                   '<li>Get on the floor</li>'\
                   '</ol>'
    Nokogiri::HTML(example_code)
  end
  let(:header_code) { code_with_everything.at('h1') }
  let(:unordered_list_code) { code_with_everything.at('ul') }
  let(:ordered_list_code) { code_with_everything.at('ol') }
  let(:paragraph_code) { code_with_everything.at('p') }

  context 'given a heading' do
    it 'bolds the text' do
      expect(Formatter.format_for_slack(header_code)).to eql('*This is a heading*')
    end
  end

  context 'given an unordered list' do
    it 'uses hyphens to make a list' do
      expect(Formatter.format_for_slack(unordered_list_code)).to eql("- Eggs\n>- Milk")
    end
  end

  context 'given an ordered list' do
    it 'uses numbers to make a list' do
      expect(Formatter.format_for_slack(ordered_list_code)).to eql("1. Open the door\n>2. Get on the floor")
    end
  end

  context 'given some other element' do
    it 'outputs the text only' do
      expect(Formatter.format_for_slack(paragraph_code)).to eql('A paragraph with a link.')
    end
  end
end
