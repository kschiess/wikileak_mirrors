
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
    open(url) do |io|
      return true
    end
    
    # NEVER REACHED
    return false
  rescue
    false
  end
end