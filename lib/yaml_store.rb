
require 'yaml'

# A store that keeps N versions of a given Ruby object. Access always 
# happens to the newest version. Failure to open the store will just return
# nil as current object. 
#
# Objects are kept in yaml files in the given directory. Each file has a 
# unique number. There will be a 'current.yaml' that symbolically links to
# the most recent file. 
#
class YamlStore
  
  # Initializes a YamlStore from the given directory. 
  #
  def initialize(directory)
    @directory = directory
  end
  
  # Saves an object as most current object. 
  #
  def store(obj, time=Time.now)
    File.open(yaml_for(time), 'w') do |file|
      file.print obj.to_yaml
    end
    
    @current = obj
  end
  
  # Returns the most current object stored or nil.
  #
  def current
    @current
  end
  
private 
  def yaml_for(time)
    File.join(
      @directory, 
      time.strftime("%Y%m%d-%H%M.yaml"))
  end
end