require 'spec_helper'
require 'renderer'

describe Renderer do
  
  before(:each) do
    @mirror_list   = flexmock :mirror_list
    @renderer      = flexmock Renderer.new('spec/fixtures/some_template.erb', @mirror_list)
  end
  
  it 'takes two parameters' do
    lambda { Renderer.new :a, :b }.should_not raise_error
  end
  
  describe 'render_into' do
    before(:each) do
      @list = ['1', '2', '3']
      @renderer.should_receive(:extract_list).and_return @list
      
      @renderer.should_receive(:refresh)
    end
    it 'should render' do
      @renderer.render_into 'spec/generated/some_template.html'
      
      File.open('spec/generated/some_template.html', 'r') do |file|
        lines = file.readlines
        @list.include?(lines.shift.chomp).should == true
        lines.shift.should == '3'
      end
    end
  end
  
  describe 'refresh' do
    it 'delegates' do
      @mirror_list.should_receive(:refresh).once.with()
      
      @renderer.refresh
    end
  end
  describe 'extract_list' do
    it 'delegates' do
      @mirror_list.should_receive(:to_a).once.with()
      
      @renderer.extract_list
    end
  end
  describe 'template' do
    it 'returns an ERB template' do
      @renderer.template.kind_of?(ERB).should == true
    end
  end
  
end