require 'spec_helper'

describe CapSuites::Data do
  context "factory" do
    before(:each) do
      @authority = Mastery::Vat.make(CapSuites::Data.name, :factory, {})
    end

    it "accepts :make" do
      result = @authority.accept(:make, :role => "winner")

      result[:slot_authority].accept(:read).should == {:role => "winner"}.with_indifferent_access
      result[:slot_authority].accept(:write, :role => "loser").should == true
      result[:slot_authority].accept(:read).should == {:role => "loser"}.with_indifferent_access

      result[:write_authority].accept(:write, :role => "hacker").should == true
      lambda { result[:write_authority].accept(:read) }.should
        raise_error("Invalid message")

      # TODO: make the reload unnecessary
      result[:slot_authority].reload.accept(:read).should == {:role => "hacker"}.with_indifferent_access

      lambda { result[:read_authority].accept(:write, :role => "skier") }.should
        raise_error("Invalid message")
      result[:read_authority].accept(:read).should == {:role => "hacker"}.with_indifferent_access
    end
  end
end
