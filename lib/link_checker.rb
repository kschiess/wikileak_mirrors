
require 'progressbar'
require 'yaml'
require 'procrastinate'
require 'open-uri'

require 'link'

# Checks a list of links and reports duplicates and broken links to a 
# link reporter.
#
class LinkChecker
  include Procrastinate
  
  # A list of broken links (subset of links)
  attr_reader :broken
  
  # A list of good links (that answer)
  attr_reader :good
  
  # All links that have been checked for
  attr_reader :links
  
  def initialize(links)
    @links = links.map { |link| Link.new(link) }
  end
  
  class FramedIo
    def initialize
      @read, @write = IO.pipe
    end
    
    def write(msg)
      yaml_msg = msg.to_yaml
      buf = [yaml_msg.size].pack('l') + yaml_msg
      
      @write.write buf
    end
    
    def read
      sizestr = @read.read(4)
      size = sizestr.unpack('l').first

      YAML.load(@read.read(size))
    end
    
    def close
      @read.close
      @write.close
    end
  end
  
  class Worker
    def check(link, transport)
      status = link.ok? ? :ok : :broken
      transport.write [link, status]
      transport.close
    end
  end
  
  def check
    @broken = []
    @good   = []
    
    transport = FramedIo.new
    
    scheduler = Scheduler.start(
      SpawnStrategy::Throttled.new(3))

    worker = scheduler.proxy(Worker.new)
    links.each do |link|
      worker.check(link, transport)
    end
    
    # bar = ProgressBar.new('links', links.size)
    links.size.times do
      answer = transport.read
      link, status = answer
      
      if status == :broken || status == :error
        @broken << link.to_s
      else
        @good << link.to_s
      end
      # bar.inc
    end
    # bar.finish

    # scheduler.shutdown
  end
end