require 'spec_helper'

require 'wikileaks'

describe Wikileaks::Mirrors do
  describe "<- .get" do
    it "should delegate to #get" do
      flexmock(Wikileaks::Mirrors).
        new_instances.should_receive(:get).with().once
        
      Wikileaks::Mirrors.get(:args)
    end
  end
  
  context "('baseurl')" do
    let(:mirrors) { Wikileaks::Mirrors.new('baseurl') }
    
    describe "<- #get" do
      it "should call html_for(baseurl)" do
        flexmock(mirrors).
          should_receive(:scrape).
          should_receive(:html_for).once
        
        mirrors.get
      end 
      it "should scrape html and return the result" do
        flexmock(mirrors).
          should_receive(:html_for => 'html').
          should_receive(:scrape).with('html', 'baseurl').once.and_return(:result)
          
        mirrors.get.should == :result
      end 
    end
    describe "<- #html_for" do
      it "should return result from open-uri" do
        io = flexmock(:read => 'html')
        flexmock(mirrors).
          should_receive(:open).with("baseurl/mirrors.html", Proc).and_yield(io)
          
        mirrors.html_for('baseurl').should == 'html'
      end 
    end
    describe "<- scrape" do
      context "using a fixture html" do
        let(:html) { File.read(fixture('mirrors.html')) }
        let(:result) { mirrors.scrape(html, 'seed url') }
        
        subject { result }
        it { should have(1335).entries }

        it { should include('seed url') }
        it { should include('http://wikileaks.kafe-in.net') }
        
        context "entries" do
          it "should start with http://" do
            entry_re = %r(http://)
            result.first(100).each do |entry|
              entry.should match(entry_re)
            end
          end 
        end
      end
    end
  end
end