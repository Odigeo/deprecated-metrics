require 'spec_helper'

describe InstancesController do
  
  render_views

  describe "GET" do
    
    before :each do
      permit_with 200
      @instance = create :instance
      request.headers['HTTP_ACCEPT'] = "application/json"
      request.headers['X-API-Token'] = "totally-fake"
    end

    
    it "should return JSON" do
      get :show, id: @instance.instance_id
      expect(response.content_type).to eq("application/json")
    end
    
    it "should return a 400 if the X-API-Token header is missing" do
      request.headers['X-API-Token'] = nil
      get :show, id: @instance.instance_id
      expect(response.status).to eq(400)
      expect(response.content_type).to eq("application/json")
    end
    
    it "should return a 404 when the user can't be found" do
      get :show, id: -1
      expect(response.status).to eq(404)
      expect(response.content_type).to eq("application/json")
    end
    
    it "should return a 200 when successful" do
      get :show, id: @instance.instance_id
      expect(response.status).to eq(200)
      expect(response).to render_template(partial: "_instance", count: 1)
    end
    
  end
  
end
