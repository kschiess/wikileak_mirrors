require 'erb'

class Renderer
  
  attr_reader :template_path, :mirror_list
  
  def initialize template_path, mirror_list
    @template_path = template_path
    @mirror_list   = mirror_list
  end
  
  # Refreshes the list of mirrors.
  #
  def refresh
    mirror_list.refresh
  end
  
  # Extracts a list of mirrors from the
  #
  def extract_list
    mirror_list.to_a
  end
  
  # Renders an index.html from the given template path ERB.
  #
  def render_into target_path
    refresh
    
    # For the binding.
    #
    list = extract_list
    
    File.open(target_path, 'w') do |file|
      file.write template.result binding
    end
  end
  
  # Returns a template
  #
  def template
    ERB.new File.new(template_path).read, nil, '%'
  end
  
end