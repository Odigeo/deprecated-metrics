require 'spec_helper'

describe Instance do


  describe "attributes" do
    
    it "should have a name" do
      create(:instance).name.should be_a String
    end

    it "should have a description" do
      create(:instance).description.should be_a String
    end

     it "should have a creation time" do
      create(:instance).created_at.should be_a Time
    end

    it "should have an update time" do
      create(:instance).updated_at.should be_a Time
    end
  
  end


  describe "relations" do

  end



  describe "search" do
  
    describe ".collection" do
    
      before :each do
        create :instance, instance_id: 'i-12345678', name: 'foo', description: "The Foo object"
        create :instance, instance_id: 'i-23456789', name: 'bar', description: "The Bar object"
        create :instance, instance_id: 'i-34567890', name: 'baz', description: "The Baz object"
      end
      
    
      it "should return an array of Instance instances" do
        ix = Instance.collection
        ix.length.should == 3
        ix[0].should be_a Instance
      end
    
      it "should allow matches on instance_id" do
        Instance.collection(instance_id: 'NOWAI').length.should == 0
        Instance.collection(instance_id: 'i-23456789').length.should == 1
        Instance.collection(instance_id: 'i-34567890').length.should == 1
      end
      
      it "should allow matches on name" do
        Instance.collection(name: 'NOWAI').length.should == 0
        Instance.collection(name: 'bar').length.should == 1
        Instance.collection(name: 'baz').length.should == 1
      end
      
      it "should NOT allow searches on description" do
        Instance.collection(search: 'a').length.should == 0
        Instance.collection(search: 'object').length.should == 0
      end
      
      it "key/value pairs not in the index_only array should quietly be ignored" do
        Instance.collection(instance_id: 'i-12345678', aardvark: 12).length.should == 1
      end
        
    end
  end

end
