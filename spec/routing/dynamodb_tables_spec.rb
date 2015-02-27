require "spec_helper"

describe DynamoTablesController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/v1/dynamo_tables")).to route_to("dynamo_tables#index")
    end

    it "routes to #show" do
      expect(get("/v1/dynamo_tables/i-12345678")).to route_to("dynamo_tables#show", id: "i-12345678")
    end

    it "routes to #create" do
      expect(post("/v1/dynamo_tables")).to route_to("dynamo_tables#create")
    end

    it "routes to #update" do
      expect(put("/v1/dynamo_tables/i-12345678")).to route_to("dynamo_tables#update", id: "i-12345678")
    end

    it "routes to #destroy" do
      expect(delete("/v1/dynamo_tables/i-12345678")).to route_to("dynamo_tables#destroy", id: "i-12345678")
    end

    it "routes to #delete_test_tables" do
      expect(delete("/v1/dynamo_tables/test_tables")).to route_to("dynamo_tables#delete_test_tables")
    end
  end
end
