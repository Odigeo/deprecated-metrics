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

    it "should route to #refresh" do
      put("/v1/instances/refresh").should route_to("instances#refresh")
    end

    it "should route to #start" do
      put("/v1/instances/i-12345678/start").should route_to("instances#start", id: "i-12345678")
    end

    it "should route to #stop" do
      put("/v1/instances/i-12345678/stop").should route_to("instances#stop", id: "i-12345678")
    end

    it "should route to #reboot" do
      put("/v1/instances/i-12345678/reboot").should route_to("instances#reboot", id: "i-12345678")
    end

    it "should route to #terminate" do
      delete("/v1/instances/i-12345678/terminate").should route_to("instances#terminate", id: "i-12345678")
    end

  end
end
