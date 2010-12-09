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
      let(:name) { tempfile(store_time.strftime("%Y%m%d-%H%M-01.yaml")) }
      context "current yaml file" do
        it "should exist as a file" do
          File.exist?(name).should == true
        end 
        it "should store 'foobar'" do
          YAML.load_file(name).should == 'foobar'
        end 
      end
      it "should contain a symbolic link to the current file" do
        current = tempfile('current.yaml')
        File.symlink?(current).should == true
        File.readlink(current).should == name
      end
    end

    context "after a second store" do
      let(:store_time) { Time.now+1 }
      before(:each) do
        store.store 'foobar', store_time
      end
      
      context "temp directory" do
        it "should contain 3 files" do
          Dir[tempfile('*')].should have(3).entries
        end 
      end
    end
  end
end