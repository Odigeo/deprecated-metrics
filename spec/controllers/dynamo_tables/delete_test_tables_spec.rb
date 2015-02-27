require 'spec_helper'

describe DynamoTablesController do
  

  describe "DELETE test_tables" do
    
    before :each do
      permit_with 200
      request.headers['HTTP_ACCEPT'] = "application/json"
      request.headers['X-API-Token'] = "boy-is-this-fake"
    end


    it "should return JSON" do
      expect(DynamoTable).to receive(:delete_test_tables)
      delete :delete_test_tables
      expect(response.content_type).to eq("application/json")
    end
    
    it "should return a 400 if the X-API-Token header is missing" do
      request.headers['X-API-Token'] = nil
      expect(DynamoTable).not_to receive(:delete_test_tables)
      delete :delete_test_tables
      expect(response.status).to eq(400)
      expect(response.content_type).to eq("application/json")
    end
    
    it "should return a 204 when successful" do
      expect(DynamoTable).to receive(:delete_test_tables)
      delete :delete_test_tables
      expect(response.status).to eq(204)
    end
    
  end
  
end
