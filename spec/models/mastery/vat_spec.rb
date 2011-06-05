require 'spec_helper'

describe Mastery::Vat do
  context ".make" do
    it "returns an authority" do
      authority = Mastery::Vat.make("some-suite", "some-cap", :some => :data)
      authority.vat_name.should =~ /[2-7A-Z]{16}/
      authority.name.should =~ /[2-7A-Z]{16}/
      authority.suite_name.should == "some-suite"
      authority.cap_name.should == "some-cap"
      authority.data.should == {:some => :data}
    end
  end
end
