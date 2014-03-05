require "spec_helper"

describe InstancesController do
  describe "routing" do

    it "routes to #index" do
      get("/v1/instances").should route_to("instances#index")
    end

    it "routes to #show" do
      get("/v1/instances/i-12345678").should route_to("instances#show", id: "i-12345678")
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

    it "should route to #refresh, but use no versioning and thus be unreachable from the outside" do
      put("/instances/refresh").should route_to("instances#refresh")
    end

  end
end
