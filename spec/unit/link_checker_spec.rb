require 'spec_helper'

require 'link_checker'

describe LinkChecker do
  let(:checker) { LinkChecker.new(
    %w(http://www.google.com http://www.thisdoesntexistlikethis.com)
  )}
  subject { checker }
  
  context "after checking" do
    before(:each) { checker.check }
    describe "<- #broken" do
      subject { checker.broken }
      it { should include("http://www.thisdoesntexistlikethis.com") }
    end
    describe "<- #good" do
      subject { checker.good }
      it { should include("http://www.google.com") }
    end
  end
end