require 'spec_helper'

describe InstancesController do
  
  render_views

  describe "INDEX" do
    
    before :each do
      permit_with 200
      create :instance, instance_id: "i-1"
      create :instance, instance_id: "i-2"
      create :instance, instance_id: "i-3"
      request.headers['HTTP_ACCEPT'] = "application/json"
      request.headers['X-API-Token'] = "boy-is-this-fake"
    end

    
    it "should return JSON" do
      get :index
      expect(response.content_type).to eq("application/json")
    end
    
    it "should return a 400 if the X-API-Token header is missing" do
      request.headers['X-API-Token'] = nil
      get :index
      expect(response.status).to eq(400)
      expect(response.content_type).to eq("application/json")
    end
    
    it "should return a 200 when successful" do
      get :index
      expect(response.status).to eq(200)
      expect(response).to render_template(partial: "_instance", count: 3)
    end

    it "should return a collection" do
      get :index
      expect(response.status).to eq(200)
      wrapper = JSON.parse(response.body)
      expect(wrapper).to be_a Hash
      resource = wrapper['_collection']
      expect(resource).to be_a Hash
      coll = resource['resources']
      expect(coll).to be_an Array
      expect(coll.count).to eq(3)
    end

  end
  
end
