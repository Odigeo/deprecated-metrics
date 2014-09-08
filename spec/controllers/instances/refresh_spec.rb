require 'spec_helper'

describe InstancesController do
  

  describe "PUT refresh" do
    
    before :each do
      permit_with 200
      create :instance, instance_id: "i-1"
      create :instance, instance_id: "i-2"
      create :instance, instance_id: "i-3"
      request.headers['HTTP_ACCEPT'] = "application/json"
      request.headers['X-API-Token'] = "boy-is-this-fake"
    end


    it "should return JSON" do
      Instance.should_receive(:refresh_all)
      put :refresh
      response.content_type.should == "application/json"
    end
    
    it "should return a 400 if the X-API-Token header is missing" do
      request.headers['X-API-Token'] = nil
      Instance.should_not_receive(:refresh_all)
      put :refresh
      response.status.should == 400
      response.content_type.should == "application/json"
    end
    
    it "should return a 200 when successful" do
      Instance.should_receive(:refresh_all)
      put :refresh
      response.status.should == 200
    end

    it "should not return a body" do
      Instance.should_receive(:refresh_all)
      put :refresh
      response.should render_template(partial: "_instance", count: 0)
      response.body.should == ""
    end
    
  end
  
end
