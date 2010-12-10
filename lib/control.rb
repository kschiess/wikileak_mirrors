require 'renderer'

# Provides the following methods:
# * list: Lists all wikileaks mirrors.
# * render: Refreshes and renders.
# * seed: 
#
class Control
  
  attr_reader :mirror_list
  
  def initialize mirror_list
    @mirror_list = mirror_list
  end
  
  # Lists all mirrors of wikileaks.ch.
  #
  def list
    mirror_list.each do |mirror|
      puts mirror
    end
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