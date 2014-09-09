require "spec_helper"

describe DynamoTablesController do
  describe "routing" do

    it "routes to #index" do
      get("/v1/dynamo_tables").should route_to("dynamo_tables#index")
    end

    it "routes to #show" do
      get("/v1/dynamo_tables/i-12345678").should route_to("dynamo_tables#show", id: "i-12345678")
    end

    it "routes to #create" do
      post("/v1/dynamo_tables").should route_to("dynamo_tables#create")
    end

    it "routes to #update" do
      put("/v1/dynamo_tables/i-12345678").should route_to("dynamo_tables#update", id: "i-12345678")
    end

    it "routes to #destroy" do
      delete("/v1/dynamo_tables/i-12345678").should route_to("dynamo_tables#destroy", id: "i-12345678")
    end

    it "routes to #delete_test_tables" do
      put("/v1/dynamo_tables/delete_test_tables").should route_to("dynamo_tables#delete_test_tables")
    end
  end
end
