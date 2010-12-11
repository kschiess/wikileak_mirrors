
require 'yaml'
require 'procrastinate'

require 'link'

# Checks a list of links and reports duplicates and broken links to a 
# link reporter.
#
class LinkChecker
  include Procrastinate
  
  # A list of broken links (subset of links)
  attr_reader :broken
  
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
      buf = msg.to_yaml
      
      @write.write [buf.size].pack('l')
      @write.write buf
    end
    
    def read
      sizestr = @read.read(4)
      size = sizestr.unpack('l').first
      
      YAML.load(@read.read(size))
    end
  end
  
  class Worker
    def check(link, transport)
      puts "Checking #{link}"

      status = link.ok? ? :ok : :broken
      transport.write [link, status]
    rescue => b
      p [:err, b]
    end
  end
  
  def check
    @broken = []
    
    transport = FramedIo.new
    
    scheduler = Scheduler.start(
      DispatchStrategy::Throttled.new(10))

    worker = scheduler.create_proxy(Worker.new)
    links.each do |link|
      worker.check(link, transport)
    end
    
    links.size.times do
      answer = transport.read
      link, status = answer
      
      if status == :broken
        @broken << link.to_s
      end
    end

    scheduler.shutdown
  end
end