require 'spec_helper'

describe DynamoTablesController do
  

  describe "PUT delete_test_tables" do
    
    before :each do
      permit_with 200
      request.headers['HTTP_ACCEPT'] = "application/json"
      request.headers['X-API-Token'] = "boy-is-this-fake"
    end


    it "should return JSON" do
      DynamoTable.should_receive(:delete_test_tables)
      put :delete_test_tables
      response.content_type.should == "application/json"
    end
    
    it "should return a 400 if the X-API-Token header is missing" do
      request.headers['X-API-Token'] = nil
      DynamoTable.should_not_receive(:delete_test_tables)
      put :delete_test_tables
      response.status.should == 400
      response.content_type.should == "application/json"
    end
    
    it "should return a 204 when successful" do
      DynamoTable.should_receive(:delete_test_tables)
      put :delete_test_tables
      response.status.should == 204
    end
    
  end
  
end
