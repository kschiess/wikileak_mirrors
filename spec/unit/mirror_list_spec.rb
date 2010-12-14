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
  
  describe 'weed' do
    before(:each) do
      @link_checker = flexmock :link_checker, :check => nil
      flexmock(LinkChecker).should_receive :new => @link_checker
      
      flexmock(@link_checker).should_receive :good => :good_list
    end
    it 'checks using the link checker' do
      @link_checker.should_receive(:check).once.with()
      
      list.weed
    end
    it 'uses the good and saves it' do
      store = flexmock :store
      flexmock(list).should_receive :store => store
      
      store.should_receive(:store).once.with :good_list
      
      list.weed
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
  context "when mirror store is seeded" do
    before(:each) { flexmock(list, :list => ['other url']) }
    context "when open from seed url fails" do
      before(:each) { flexmock(list).
        should_receive(:retrieve_mirrors).with('seed url').and_raise('hell').
        should_receive(:retrieve_mirrors).and_return(:list) 
      }
      it "should try urls from the store" do
        list.refresh
      end
    end
  end
end