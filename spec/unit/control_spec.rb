require 'spec_helper'

require 'control'

describe Control do
  let(:control) { Control.new mirror_list }
  let(:mirror_list) { flexmock :mirror_list }
  let(:output) { StringIO.new }
  
  # Silences the control script
  before(:each) { 
    @old_stdout = $stdout
    $stdout = output
  }
  after(:each) { 
    $stdout = @old_stdout
  }
  
  it 'has a reader for the mirror_list' do
    control.mirror_list.should == mirror_list
  end
  
  describe 'refresh' do
    it 'delegates to the mirror list' do
      flexmock(control).should_receive(:puts).once # silence/test
      mirror_list.should_receive(:refresh).once.with()
      
      control.refresh
    end
  end
  
  describe 'seed' do
    it 'receives methods in order' do
      flexmock(control).should_receive(:refresh).once.with().ordered
      flexmock(control).should_receive(:list).once.with().ordered
      
      control.seed
    end
  end
  
  describe 'list' do
    context "with a list of one element" do
      before(:each) { mirror_list.
        should_receive(:each).and_yield(:some_mirror).
        should_receive(:list => [:some_mirror]) 
      }
      it 'puts each' do      
        control.list
        
        output.string.should include('some_mirror')
      end
    end
  end
  
end