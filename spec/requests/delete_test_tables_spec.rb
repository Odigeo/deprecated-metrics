require 'spec_helper'

describe DynamoTable, :type => :request do

  before :each do
    permit_with 200
  end


  describe "delete_test_tables" do

    it "should behave as expected" do
      expect(DynamoTable).to receive(:delete_test_tables).with(CHEF_ENV)
      delete "/v1/dynamo_tables/test_tables", 
          {}, 
          {'HTTP_ACCEPT' => "application/json", 'X-API-TOKEN' => "incredibly-fake"}
      expect(response.status).to eq 204
    end

  end

end 
