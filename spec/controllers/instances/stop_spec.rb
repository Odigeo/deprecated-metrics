require 'spec_helper'

describe InstancesController do
  

  describe "PUT stop" do
    
    before :each do
      permit_with 200
      @instance = create :instance, state: "running"
      request.headers['HTTP_ACCEPT'] = "application/json"
      request.headers['X-API-Token'] = "totally-fake"
    end

    it "should return a 404 when the user can't be found" do
      @instance.should_not_receive(:stop)
      put :stop, id: -1
      response.status.should == 404
      response.content_type.should == "application/json"
    end

    it "should return a 200" do
      Instance.any_instance.should_receive(:stop)
      put :stop, id: @instance.instance_id
      response.status.should == 200
    end
    
    it "should not return a body" do
      Instance.any_instance.should_receive(:stop)
      put :stop, id: @instance.instance_id
      response.body.should == ""
    end
    
  end
  
end
