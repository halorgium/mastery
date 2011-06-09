require 'spec_helper'

describe CapSuites::Eventual do
  context "factory" do
    before(:each) do
      @authority = Mastery::Vat.make(CapSuites::Eventual.name, :factory, {})
    end

    it "returns a promise and resolver" do
      result = @authority.accept(:make)
      promise_authority = result[:promise_authority]
      resolver_authority = result[:resolver_authority]

      promise_authority.as_hash.should == {:resolved => false, :data => nil}.with_indifferent_access
      resolver_authority.accept(:resolve_with, "zomg").should == true
      promise_authority.as_hash.should == {:resolved => true, :data => "zomg"}.with_indifferent_access
    end
  end
end
