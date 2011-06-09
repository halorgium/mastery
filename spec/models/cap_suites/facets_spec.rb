require 'spec_helper'

describe CapSuites::Facets do
  context "proxy" do
    before(:each) do
      @inner_authority = Mastery::Vat.make(CapSuites::Data.name, :slot, :name => "Bob")
      @authority = Mastery::Vat.make(CapSuites::Facets.name, :proxy, {:inner_authority => @inner_authority.url, :allowed => [:read]})
    end

    it "filters messages" do
      @authority.accept(:read).should == {:name => "Bob"}.with_indifferent_access
      lambda { @authority.accept(:write) }.
        should raise_error("Invalid message")
    end
  end
end
