require 'renderer'

# Provides the following methods:
# * list: Shows the latest cached list of wikileaks mirrors.
# * render: Refreshes and renders.
# * seed: Refreshes and shows the list.
#
class Control
  
  attr_reader :mirror_list
  
  # A Control object takes a mirror list on which to operate.
  #
  def initialize mirror_list
    @mirror_list = mirror_list
  end
  
  # Lists all mirrors of wikileaks.ch.
  #
  def list
    dupe_checker = Hash.new(0)
    mirror_list.each do |mirror|
      dupe_checker[mirror] += 1
      puts mirror
    end
    
    puts
    puts "Duplicates found:"
    dupe_checker.
      reject { |k,v| v<=2 }.
      each do |k,v|
        puts "#{k}: #{v}"
      end
    puts "#{mirror_list.list.size} mirrors."
  end
  
  # 1. Refreshes the list of mirrors.
  # 2. Renders into index.html.
  #
  def render source = 'templates/index.erb', target = 'index.html'
    refresh
    renderer = renderer_for source
    renderer.render_into target
  end
  def renderer_for source
    Renderer.new source, mirror_list
  end
  
  # 1. Refreshes the mirror list.
  # 2. Shows the list.
  #
  def seed
    refresh
    list
  end
  
  # Refresh the mirror list.
  #
  def refresh
    puts "Fetching mirrors..."
    mirror_list.refresh
  end
  
end