require 'scrapi'
require 'open-uri'

# Scrapes the wikileaks mirror count from http://wikileaks.ch/mirrors.html.
#
class WikileaksMirrorCount
  
  def initialize(url)
    @url = url
    @wikileaks_mirrors = Scraper.define do
      process "h3 + p", :text => :text
      
      result :text
    end
  end
  
  def get
    open(@url) do |html|
      mirrors_text = @wikileaks_mirrors.scrape(html.read)
      
      if md = mirrors_text.match(/mirrored on (?<count>\d+) sites/)
        return Integer(md[:count])
      end
    end
    
    fail 'Could not retrieve the mirror count!'
  end
end