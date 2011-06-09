require 'spec_helper'

describe CapSuites::Root do
  context "factory" do
    before(:each) do
      @authority = Mastery::Vat.make(CapSuites::Root.name, :factory, {})
    end

    it "returns a new vat authority" do
      result = @authority.accept(:make, CapSuites::Root.name, :factory, {})
      root_authority = result[:root_authority]
      root_authority.vat_name.should_not == @authority.vat_name
      root_authority.suite_name.should == CapSuites::Root.name
      root_authority.cap_name.should == "factory"
    end
  end
end
