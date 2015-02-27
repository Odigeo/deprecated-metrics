require "spec_helper"

describe InstancesController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/v1/instances")).to route_to("instances#index")
    end

    it "routes to #show" do
      expect(get("/v1/instances/i-12345678")).to route_to("instances#show", id: "i-12345678")
    end

    it "should not route to #create" do
      expect(post("/v1/instances")).not_to be_routable
    end

    it "should not route to #update" do
      expect(put("/v1/instances/1")).not_to be_routable
    end

    it "should not route to #destroy" do
      expect(delete("/v1/instances/1")).not_to be_routable
    end

    it "should route to #refresh" do
      expect(put("/v1/instances/refresh")).to route_to("instances#refresh")
    end

    it "should route to #start" do
      expect(put("/v1/instances/i-12345678/start")).to route_to("instances#start", id: "i-12345678")
    end

    it "should route to #stop" do
      expect(put("/v1/instances/i-12345678/stop")).to route_to("instances#stop", id: "i-12345678")
    end

    it "should route to #reboot" do
      expect(put("/v1/instances/i-12345678/reboot")).to route_to("instances#reboot", id: "i-12345678")
    end

    it "should route to #terminate" do
      expect(delete("/v1/instances/i-12345678/terminate")).to route_to("instances#terminate", id: "i-12345678")
    end

  end
end
