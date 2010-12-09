
require 'wikileaks'
require 'yaml_store'

# A persistent list of mirrors.
#
class MirrorList
  # The backend store
  attr_reader :store
  
  # Create a mirror list instance. +store_dir+ is the directory where all
  # yaml cache files will be stored. +seed_url+ is the url that will be asked
  # for a mirror list if no existing list can be found in the store. 
  #
  def initialize(store_dir, seed_url)
    @seed_url = seed_url
    @store = YamlStore.new(store_dir)
  end
  
  # Refreshes all mirrors by asking one of the mirrors for an up to date list. 
  # This list is then stored and becomes the current list. 
  #
  def refresh
    # Try as many urls from the list as needed to get a non nil result. 
    new_list = retrieve
    store.store new_list
  end
  
  # Implement Enumerable. If you want to be sure to have a list of mirrors,
  # whether or not a previous list has been retrieved, then call #refresh
  # before using the collection. 
  #
  def each(&block)
    list.each(&block)
  end
  include Enumerable
  
  # Tries as many mirrors as needed to get a valid result.
  def retrieve
    each do |url|
      begin
        return retrieve_mirrors(url)
      rescue => b
        # Something bad happened - just continue trying all mirrors
        puts "Mirror #{url}: #{b} (retrying with other urls...)"
      end
    end
    
    fail "Could not fetch a current list - none of the mirrors answered. Try reseeding."
  end

  # Retrieves the mirror list using the baseurl as mirror. 
  #
  def retrieve_mirrors(baseurl)
    Wikileaks::Mirrors.get(baseurl)
  end
  
  # Returns the current list
  #
  def list
    @store.current || [@seed_url] 
  end
end