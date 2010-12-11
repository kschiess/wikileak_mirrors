
require 'open-uri'
require 'scrapi'

# Models a list of mirror locations.
#
class Wikileaks::Mirrors
  
  attr_reader :baseurl
  def initialize(baseurl)
    @baseurl = baseurl
  end
  
  # Retrieves a list of mirrors from the mirror page below +baseurl+.
  #
  def get()
    html = html_for(baseurl)
    scrape html, baseurl
  end
  def self.get(baseurl)
    new(baseurl).get
  end
  
  def html_for(url)
    open(url + "/mirrors.html") do |io|
      io.read
    end
  end
  
  def scrape(html, seed_url)
    urls = scraper.scrape(html) 
    urls << seed_url
    
    urls
  end
  
  def scraper
    @scraper ||= Scraper.define do
      array :href
      process "td a", :href => "@href"
      result :href
    end
  end
end