require 'spec_helper'

require 'tempfile'

require 'yaml_store'

describe YamlStore do
  attr_reader :temp_path
  before(:each) do
    tempfile = Tempfile.new('yamlstore')
    path = tempfile.path
    tempfile.close(true)
    
    FileUtils.mkdir_p(path)
    @temp_path = path
  end
  after(:each) do
    FileUtils.rm_rf(@temp_path)
  end

  def tempfile(*components)
    File.join(temp_path, *components)
  end

  let(:store) { YamlStore.new(temp_path) }
  subject { store }
  
  its(:current) { should be_nil }
  
  context "after a single store" do
    let(:store_time) { Time.now }
    before(:each) do
      store.store 'foobar', store_time
    end
    
    its(:current) { should == 'foobar' }
    
    describe "temp directory" do
      it "should contain a yaml file storing 'foobar'" do
        name = store_time.strftime("%Y%m%d-%H%M.yaml")
        File.exist?(tempfile(name)).should == true
      end
      it "should contain a symbolic link to the current file"
    end
  end
end