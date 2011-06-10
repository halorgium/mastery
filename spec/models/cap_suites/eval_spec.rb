require 'spec_helper'

describe CapSuites::Eval do
  context "factory" do
    before(:each) do
      @authority = Mastery::Vat.make(CapSuites::Eval.name, :factory, {})
    end

    it "returns a new vat authority" do
      code = <<-EOT
        args.reverse
      EOT
      result = @authority.accept(:make, code)
      runner_authority = result[:runner_authority]
      run_result = runner_authority.accept(:run, 1, 2, 3)
      run_result.should == [3, 2, 1]
    end
  end
end
