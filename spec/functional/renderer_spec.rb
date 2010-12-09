require 'spec_helper'
require 'renderer'

describe Renderer do
  
  before(:each) do
    @renderer = flexmock Renderer.new('templates/index.erb', :unimportant)
  end
  
  # We'd like to see if our template renders when provided with an enumerable.
  #
  describe 'render_into' do
    before(:each) do
      @renderer.should_receive(:refresh)
      
      @list = ['1', '2', '3']
      @renderer.should_receive(:extract_list).and_return @list
    end
    it 'should render without fail' do
      @renderer.render_into 'spec/fixtures/some_template.html'
    end
  end
  
end