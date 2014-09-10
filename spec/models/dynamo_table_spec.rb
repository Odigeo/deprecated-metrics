require 'spec_helper'

describe DynamoTable do

  describe "class method delete_test_tables" do

  	before :each do
  	  expect(DynamoTable).to receive(:obtain_all_dynamodb_tables).
  	    and_return(["foo_master", 
  	    	        "foo_staging", 
  	    	        "foo_prod", 
  	    	        "foo_master_1-12-123-12_test",
  	    	        "foo_dev_1-12-123-12_test",
  	    	        "foo_staging_1-12-123-12_test",
  	    	        "bar_mitzvah",
  	    	        "bar_none"
  	    	       ])
  	end


  	it "should obtain the list of DynamoDB table names" do
  	  allow(DynamoTable).to receive(:delete_table)
  	  DynamoTable.delete_test_tables("master")
  	end

  	it "should call purgeable? for each table" do
  	  expect(DynamoTable).to receive(:purgeable?).exactly(8).times.and_return(false)
  	  DynamoTable.delete_test_tables("master")
  	end

  	it "should call delete_table whenever purgeable? is true" do
  	  expect(DynamoTable).to receive(:purgeable?).exactly(8).times.
  	    and_return(false, false, false, true, true, false, false, false)
  	  expect(DynamoTable).to receive(:delete_table).exactly(2).times
  	  DynamoTable.delete_test_tables("master")
  	end

  	it "should call delete_table twice for the test table list" do
  	  expect(DynamoTable).to receive(:delete_table).twice
  	  DynamoTable.delete_test_tables("master")
  	end
  end


  describe "class method purgeable?" do
    
    it "should return false if the table name doesn't end in '_test'" do
      expect(DynamoTable.purgeable? "foo_master_1-12-123-12_whatever", "master").to eq false
      expect(DynamoTable.purgeable? "foo_master_1-12-123-12test", "master").to eq false
    end

    it "should return false if there's no IP number in the name" do
      expect(DynamoTable.purgeable? "foo_test", "staging").to eq false
      expect(DynamoTable.purgeable? "foo_staging_1-12-123_test", "staging").to eq false
      expect(DynamoTable.purgeable? "foo_staging1-12-123-12test", "staging").to eq false
    end

    it "should return false if the chef_env doesn't match" do
      expect(DynamoTable.purgeable? "foo_test", "staging").to eq false
      expect(DynamoTable.purgeable? "foo_staging_1-12-123-12_test", "prod").to eq false
    end

    it "should return true for a correctly formed and matching name" do
      expect(DynamoTable.purgeable? "foo_staging_1-12-123-12_test", "staging").to eq true
      expect(DynamoTable.purgeable? "foo_bar_staging_1-12-123-12_test", "staging").to eq true
    end

    it "when the table name contains 'dev' as its chef_env, should return true only for master" do
      expect(DynamoTable.purgeable? "foo_dev_1-12-123-12_test", "staging").to eq false
      expect(DynamoTable.purgeable? "foo_dev_1-12-123-12_test", "master").to eq true
    end
  end


  describe "class method delete_table" do

  	it "should call AWS properly" do
  	  expect($dynamo).to receive(:delete_table).with({table_name: "godzilla"})
  	  DynamoTable.delete_table("godzilla")
  	end

  end

end
