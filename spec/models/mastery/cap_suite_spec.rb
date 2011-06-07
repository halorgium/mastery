require 'spec_helper'

describe Mastery::CapSuite do
  def build(&block)
    Class.new(Mastery::CapSuite, &block)
  end

  before(:each) do
    @suite = build do
      define :mirror do
        accepts :echo do |message|
          message
        end

        accepts :reverse_echo do |message|
          message.reverse
        end
      end

      define :calculator do
        accepts :add do |a,b|
          a + b
        end

        accepts :substract do |a,b|
          a - b
        end
      end
    end
  end

  it "define caps" do
    @suite.should have(2).caps
    @suite.cap_names.sort.should == %w( calculator mirror ).sort
  end

  context "with messages" do
    before(:each) do
      @mirror = @suite[:mirror]
      @calculator = @suite[:calculator]
    end

    it "exists" do
      @mirror.should have(2).messages
      @calculator.should have(2).messages
    end

    it "accepts messages" do
      @mirror.accept(:echo, "123").should == "123"
      @mirror.accept(:reverse_echo, "123").should == "321"

      @calculator.accept(:add, 123, 321).should == 444
      @calculator.accept(:substract, 321, 123).should == 198
    end

    it "raises when invalid message" do
      lambda { @mirror.accept(:missing) }.
        should raise_error("Invalid message")
    end

    it "raises when invalid arity" do
      lambda { @mirror.accept(:echo) }.
        should raise_error("Invalid arity")
    end
  end
end
