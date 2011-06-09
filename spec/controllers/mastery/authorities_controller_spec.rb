require 'spec_helper'

describe Mastery::AuthoritiesController do
  before(:each) do
    @authority = Mastery::Vat.make(CapSuiteFixtures::Simple.name, :mirror, {})
  end

  context "#show" do
    it "returns the authority" do
      get :show, {:vat_id => @authority.vat_name, :id => @authority.name, :format => :json}
      response.status.should == 200
      response.body.should == '{"class":"CapSuiteFixtures::Simple.mirror","url":"' + @authority.url + '"}'
    end
  end

  context "#update" do
    it "returns the authority" do
      put :update, {:vat_id => @authority.vat_name, :id => @authority.name, :message => "echo", :args => ["hello"], :format => :json}
      response.status.should == 200
      response.body.should == '{"result":"hello"}'
    end
  end
end
