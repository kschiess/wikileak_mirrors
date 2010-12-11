require 'spec_helper'

require 'link'

describe Link do
  let(:link) { Link.new('http://www.someurl.com') }
  subject { link }

  describe "<- #to_s" do
    subject { link.to_s }
    it { should == 'http://www.someurl.com' }
  end
  describe "<- #ok?" do
    context "when open fails" do
      before(:each) { flexmock(link).should_receive(:open).and_raise('fail') }
      subject { link.ok? }
      it { should == false }
    end
    context "when open succeeds" do
      before(:each) { flexmock(link).should_receive(:open).and_yield('ok') }
      subject { link.ok? }
      it { should == true }
    end
  end
end