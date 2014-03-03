# == Schema Information
#
# Table name: instances
#
#  id           :integer          not null, primary key
#  instance_id  :string(255)
#  name         :string(255)
#  description  :string(255)
#  chef_env     :string(255)
#  service      :string(255)
#  subservice   :string(255)
#  contents     :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  lock_version :integer          default(0), not null
#
# Indexes
#
#  index_instances_on_chef_env_and_name     (chef_env,name)
#  index_instances_on_chef_env_and_service  (chef_env,service)
#  index_instances_on_instance_id           (instance_id)
#

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
  
    it "should have a chef environment" do
      create(:instance).chef_env.should be_a String
    end
  
    it "should have a service" do
      create(:instance).service.should be_a String
    end
  
    it "should have a subservice" do
      create(:instance).subservice.should be_a String
    end
  
    it "should have contents hash" do
      create(:instance, contents: {}).contents.should be_a Hash
    end

    it "should be able to serialize and persist the contents hash" do
      i = create(:instance, contents: {foo: 2, 'bar' => [1,2,3]})
      i = Instance.find(i)
      i.contents.should == {"foo"=>2, "bar"=>[1, 2, 3]}
      i.contents['bar'] = :quux
      i.save!
      i = Instance.find(i)
      i.contents.should == {"foo"=>2, "bar"=>"quux"}
    end
  
  end


  describe "search" do
  
    describe ".collection" do
    
      before :each do
        create :instance, instance_id: 'i-12345678', name: 'foo', chef_env: "master", service: "quux"
        create :instance, instance_id: 'i-23456789', name: 'bar', chef_env: "prod",   service: "quux"
        create :instance, instance_id: 'i-34567890', name: 'baz', chef_env: "master", service: "zuul"
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
      
      it "should allow matches on chef_env" do
        Instance.collection(chef_env: 'NOWAI').length.should == 0
        Instance.collection(chef_env: 'master').length.should == 2
        Instance.collection(chef_env: 'prod').length.should == 1
      end
      
      it "should allow matches on service" do
        Instance.collection(service: 'NOWAI').length.should == 0
        Instance.collection(service: 'quux').length.should == 2
        Instance.collection(service: 'zuul').length.should == 1
      end
            
      it "should allow combined matches" do
        Instance.collection(chef_env: "prod", service: "quux").length.should == 1
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


  describe "refresh_all" do

    it "should be available as a class method" do
      Instance.should respond_to(:refresh_all)
    end

    it "should call refresh_from_struct repeatedly" do
      Instance.should_receive(:refresh_from_struct).at_least(1).times
      Instance.refresh_all
    end
  end


  describe "refresh_from_struct" do

    it "should try to receive the instance from its id" do
      Instance.should_receive(:find_by_instance_id)
      Instance.refresh_from_struct({'tags' => {}})
    end

    it "should create an instance if not found" do
      Instance.should_receive(:create!)
      Instance.refresh_from_struct({'instance_id' => 'UNKNOWN', 'tags' => {}})
    end

    it "should update an instance if it already exists and is different" do
      create(:instance, instance_id: "i-12345678", contents: {})
      Instance.should_not_receive(:create!)
      Instance.any_instance.should_receive(:update_attributes)
      Instance.refresh_from_struct({'instance_id' => 'i-12345678', 'tags' => {}, 'contents' => 'another'})
    end

    it "should not update an instance if it already exists but is unchanged" do
      create(:instance, instance_id: "i-99999999", contents: {'instance_id' => 'i-99999999', 'tags' => {}, 'contents' => {'tags' => {}}})
      Instance.should_not_receive(:create!)
      Instance.any_instance.should_not_receive(:update_attributes)
      Instance.refresh_from_struct({'instance_id' => 'i-99999999', 'tags' => {}, 'contents' => {'tags' => {}}})
    end

  end

end
