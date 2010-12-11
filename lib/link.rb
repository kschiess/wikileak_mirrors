
require 'timeout'

# A http link class that allows for simple link checking. 
#
class Link
  attr_reader :url
  def initialize(url)
    @url = url
  end
  
  def to_s
    url
  end
  
  def ok?
    timeout(5) do
      open(url) do |io|
        return true
      end
    end
    
    # NEVER REACHED
    return false
  rescue
    false
  end
end