require 'spec_helper'

require 'tempfile'

require 'mirror_list'

describe MirrorList do
  attr_reader :temp_path
  before(:each) do
    tempfile = Tempfile.new('mirrorlist')
    path = tempfile.path
    tempfile.close(true)
    
    FileUtils.mkdir_p(path)
    @temp_path = path
  end
  after(:each) do
    FileUtils.rm_rf(@temp_path)
  end
  
  let(:list) { MirrorList.new(temp_path, 'seed url') }

  describe "<- #retrieve_mirrors(baseurl)" do
    it "should delegate to Wikileaks::Mirror.retrieve(baseurl)" do
      flexmock(Wikileaks::Mirrors).
        should_receive(:get).with('baseurl').once
        
      list.retrieve_mirrors('baseurl')
    end
  end
  
  context "when mirror store is empty" do
    describe "<- #refresh" do
      it "should retrieve mirrors from seed url" do
        flexmock(list).
          should_receive(:retrieve_mirrors).with('seed url').once
          
        list.refresh
      end
      it "should store current mirrors" do
        flexmock(list).should_receive(:retrieve_mirrors => :list)
        list.refresh
        
        list.store.current.should == :list
      end
    end
    describe "#each" do
      it "should return just the seed url" do
        yields = 0
        list.each do |url|
          yields += 1
          url.should == 'seed url'
        end
        
        yields.should == 1
      end
    end
  end
end