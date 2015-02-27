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
      expect(@instance).not_to receive(:stop)
      put :stop, id: -1
      expect(response.status).to eq(404)
      expect(response.content_type).to eq("application/json")
    end

    it "should return a 200" do
      expect_any_instance_of(Instance).to receive(:stop)
      put :stop, id: @instance.instance_id
      expect(response.status).to eq(200)
    end
    
    it "should not return a body" do
      expect_any_instance_of(Instance).to receive(:stop)
      put :stop, id: @instance.instance_id
      expect(response.body).to eq("")
    end
    
  end
  
end
