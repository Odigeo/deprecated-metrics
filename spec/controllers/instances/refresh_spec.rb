require 'spec_helper'

describe InstancesController do
  

  describe "PUT" do
    
    it "should require no authentication or authorisation and return a 200" do
      Instance.should_receive(:refresh_all)
      put :refresh
      response.status.should == 200
    end
    
    it "should not return a body" do
      Instance.should_receive(:refresh_all)
      put :refresh
      response.body.should == ""
    end
    
  end
  
end
