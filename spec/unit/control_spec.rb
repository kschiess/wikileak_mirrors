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
  
  describe 'render(source, target)' do
    before(:each) do
      @renderer = flexmock :renderer
      flexmock(control).should_receive(:refresh).once.with()
    end
    context 'default' do
      it 'uses a default source and target' do
        control.should_receive(:renderer_for).once.with('templates/index.erb').and_return @renderer
        @renderer.should_receive(:render_into).once.with 'index.html'
        
        control.render
      end
    end
    context 'with source' do
      it 'uses the given source and default target' do
        control.should_receive(:renderer_for).once.with('some/source').and_return @renderer
        @renderer.should_receive(:render_into).once.with 'index.html'
        
        control.render 'some/source'
      end
    end
    context 'with two params' do
      it 'uses the given source and target' do
        control.should_receive(:renderer_for).once.with('some/source').and_return @renderer
        @renderer.should_receive(:render_into).once.with 'some/target'
        
        control.render 'some/source', 'some/target'
      end
    end
  end
  
  describe 'renderer_for(source)' do
    it 'returns a Renderer' do
      control.renderer_for('some/source').should be_kind_of(Renderer)
    end
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