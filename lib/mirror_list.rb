
# A persistent list of mirrors.
#
class MirrorList
  # Create a mirror list instance. +store_dir+ is the directory where all
  # yaml cache files will be stored. +seed_url+ is the url that will be asked
  # for a mirror list if no existing list can be found in the store. 
  #
  def initialize(store_dir, seed_url)
  end
  
  # Refreshes all mirrors by asking one of the mirrors for an up to date list. 
  # This list is then stored and becomes the current list. 
  #
  def refresh
  end
  
  # Implement Enumerable. If you want to be sure to have a list of mirrors,
  # whether or not a previous list has been retrieved, then call #refresh
  # before using the collection. 
  #
  def each
  end
  include Enumerable
end