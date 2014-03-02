require "spec_helper"

describe InstancesController do
  describe "routing" do

    it "routes to #index" do
      get("/v1/instances").should route_to("instances#index")
    end

    it "routes to #show" do
      get("/v1/instances/1").should route_to("instances#show", id: "1")
    end

    it "should not route to #create" do
      post("/v1/instances").should_not be_routable
    end

    it "should not route to #update" do
      put("/v1/instances/1").should_not be_routable
    end

    it "should not route to #destroy" do
      delete("/v1/instances/1").should_not be_routable
    end

  end
end
