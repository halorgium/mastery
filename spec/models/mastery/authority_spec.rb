require 'spec_helper'

describe Mastery::Authority do
  before(:each) do
    @authority = Mastery::Vat.make(CapSuiteFixtures::Simple.name, :mirror, {})
  end

  context "#accept" do
    it "runs" do
      @authority.accept(:echo, "Hello").should == "Hello"
      @authority.accept(:reverse_echo, "Goodbye").should == "eybdooG"
    end
  end
end
