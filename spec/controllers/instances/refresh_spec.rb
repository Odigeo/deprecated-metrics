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
      expect(Instance).to receive(:refresh_all)
      put :refresh
      expect(response.content_type).to eq("application/json")
    end
    
    it "should return a 400 if the X-API-Token header is missing" do
      request.headers['X-API-Token'] = nil
      expect(Instance).not_to receive(:refresh_all)
      put :refresh
      expect(response.status).to eq(400)
      expect(response.content_type).to eq("application/json")
    end
    
    it "should return a 200 when successful" do
      expect(Instance).to receive(:refresh_all)
      put :refresh
      expect(response.status).to eq(200)
    end

    it "should not return a body" do
      expect(Instance).to receive(:refresh_all)
      put :refresh
      expect(response).to render_template(partial: "_instance", count: 0)
      expect(response.body).to eq("")
    end
    
  end
  
end
