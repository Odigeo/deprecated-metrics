# == Schema Information
#
# Table name: instances
#
#  id                 :integer          not null, primary key
#  instance_id        :string(255)
#  name               :string(255)
#  description        :string(255)
#  chef_env           :string(255)
#  service            :string(255)
#  subservice         :string(255)
#  contents           :text
#  created_at         :datetime
#  updated_at         :datetime
#  lock_version       :integer          default(0), not null
#  state              :string(255)
#  instance_type      :string(255)
#  launch_time        :datetime
#  availability_zone  :string(255)
#  subnet_id          :string(255)
#  private_ip_address :string(255)
#
# Indexes
#
#  index_instances_on_chef_env_and_name     (chef_env,name)
#  index_instances_on_chef_env_and_service  (chef_env,service)
#  index_instances_on_instance_id           (instance_id) UNIQUE
#

require 'spec_helper'

describe Instance do


  describe "attributes" do
    
    it "should have a name" do
      expect(create(:instance).name).to be_a String
    end

    it "should have a description" do
      expect(create(:instance).description).to be_a String
    end

     it "should have a creation time" do
      expect(create(:instance).created_at).to be_a Time
    end

    it "should have an update time" do
      expect(create(:instance).updated_at).to be_a Time
    end
  
    it "should have a chef environment" do
      expect(create(:instance).chef_env).to be_a String
    end
  
    it "should have a service" do
      expect(create(:instance).service).to be_a String
    end
  
    it "should have a subservice" do
      expect(create(:instance).subservice).to be_a String
    end
  
    it "should have contents hash" do
      expect(create(:instance, contents: {}).contents).to be_a Hash
    end

    it "should be able to serialize and persist the contents hash" do
      i = create(:instance, contents: {"foo" => 2, 'bar' => [1,2,3]})
      i = Instance.find(i.id)
      expect(i.contents).to eq({"foo"=>2, "bar"=>[1, 2, 3]})
      i.contents['bar'] = "quux"
      i.save!
      i = Instance.find(i.id)
      expect(i.contents).to eq({"foo"=>2, "bar"=>"quux"})
    end
  
    it "should have a state field" do
      expect(create(:instance).state).to be_a String
    end
      
    it "should have an instance type field" do
      expect(create(:instance).instance_type).to be_a String
    end
      
    it "should have an launch time field" do
      expect(create(:instance).launch_time).to be_a Time
    end
      
    it "should have an availability zone field" do
      expect(create(:instance).availability_zone).to be_a String
    end
      
    it "should have subnet_id field" do
      expect(create(:instance).subnet_id).to be_a String
    end
      
    it "should have private_ip_address field" do
      expect(create(:instance).private_ip_address).to be_a String
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
        expect(ix.length).to eq(3)
        expect(ix[0]).to be_a Instance
      end
    
      it "should allow matches on instance_id" do
        expect(Instance.collection(instance_id: 'NOWAI').length).to eq(0)
        expect(Instance.collection(instance_id: 'i-23456789').length).to eq(1)
        expect(Instance.collection(instance_id: 'i-34567890').length).to eq(1)
      end
      
      it "should allow matches on name" do
        expect(Instance.collection(name: 'NOWAI').length).to eq(0)
        expect(Instance.collection(name: 'bar').length).to eq(1)
        expect(Instance.collection(name: 'baz').length).to eq(1)
      end
      
      it "should allow matches on chef_env" do
        expect(Instance.collection(chef_env: 'NOWAI').length).to eq(0)
        expect(Instance.collection(chef_env: 'master').length).to eq(2)
        expect(Instance.collection(chef_env: 'prod').length).to eq(1)
      end
      
      it "should allow matches on service" do
        expect(Instance.collection(service: 'NOWAI').length).to eq(0)
        expect(Instance.collection(service: 'quux').length).to eq(2)
        expect(Instance.collection(service: 'zuul').length).to eq(1)
      end
            
      it "should allow combined matches" do
        expect(Instance.collection(chef_env: "prod", service: "quux").length).to eq(1)
      end
            
      it "should NOT allow searches on description" do
        expect(Instance.collection(search: 'a').length).to eq(0)
        expect(Instance.collection(search: 'object').length).to eq(0)
      end
      
      it "key/value pairs not in the index_only array should quietly be ignored" do
        expect(Instance.collection(instance_id: 'i-12345678', aardvark: 12).length).to eq(1)
      end
        
    end
  end


  describe "refresh_all" do

    it "should be available as a class method" do
      expect(Instance).to respond_to(:refresh_all)
    end

    it "should call refresh_from_struct repeatedly" do
      expect($ec2).to receive(:describe_instances).
        and_return(double('ec2_reply', reservations: [double('reservation', instances: [double('i', instance_id: "i-12345678")])]))
      expect(Instance).to receive(:refresh_from_struct).once
      Instance.refresh_all
    end

    it "should destroy instances not in the result set" do
      i1 = create :instance, instance_id: "i-11111111"
      i2 = create :instance, instance_id: "i-22222222"
      i3 = create :instance, instance_id: "i-33333333"
      i4 = create :instance, instance_id: "i-44444444"
      expect(Instance.count).to eq(4)
      expect($ec2).to receive(:describe_instances).
        and_return(double('ec2_reply', 
          reservations: [double('reservation-1', instances: [double('i3', instance_id: "i-33333333")]),
                         double('reservation-2', instances: [double('i1', instance_id: "i-11111111")])
                        ]))
      expect(Instance).to receive(:refresh_from_struct).twice
      Instance.refresh_all
      expect(Instance.count).to eq(2)
      expect(Instance.find_by_instance_id("i-11111111")).to eq(i1)
      expect(Instance.find_by_instance_id("i-22222222")).to eq(nil)
      expect(Instance.find_by_instance_id("i-33333333")).to eq(i3)
      expect(Instance.find_by_instance_id("i-44444444")).to eq(nil)
    end
  end


  describe "refresh_from_struct" do

    it "should try to receive the instance from its id" do
      expect(Instance).to receive(:find_by_instance_id)
      Instance.refresh_from_struct({'tags' => {}, 'state' => {}, 'placement' => {}})
    end

    it "should create an instance if not found" do
      expect(Instance).to receive(:create!)
      Instance.refresh_from_struct({'instance_id' => 'UNKNOWN', 'tags' => {}, 'state' => {}, 'placement' => {}})
    end

    it "should update an instance if it already exists and is different" do
      create(:instance, instance_id: "i-12345678", contents: {})
      expect(Instance).not_to receive(:create!)
      expect_any_instance_of(Instance).to receive(:update_attributes)
      Instance.refresh_from_struct({'instance_id' => 'i-12345678', 'tags' => {}, 
                                    'state' => {}, 'placement' => {}})
    end

    it "should not update an instance if it already exists but is unchanged" do
      create(:instance, instance_id: "i-99999999", contents: {'instance_id' => 'i-99999999', 'tags' => {}, 
                                                              'state' => {}, 'placement' => {}})
      expect(Instance).not_to receive(:create!)
      expect_any_instance_of(Instance).not_to receive(:update_attributes)
      Instance.refresh_from_struct({'instance_id' => 'i-99999999', 'tags' => {}, 
                                    'state' => {}, 'placement' => {}})
    end
  end


  describe "start" do
    it "should take an optional string argument" do
      expect($ec2).to receive(:start_instances).twice
      @i = create :instance
      @i.start("This is the reason for starting")
      Instance.delete_all
      @i = create :instance
      @i.start
    end

    it "should call Amazon" do
      @i = create :instance
      expect($ec2).to receive(:start_instances).with(instance_ids: [@i.instance_id])
      @i.start
    end
  end


  describe "stop" do
    it "should call Amazon" do
      @i = create :instance
      expect($ec2).to receive(:stop_instances).with(instance_ids: [@i.instance_id])
      @i.stop
    end
  end


  describe "reboot" do
    it "should call Amazon" do
      @i = create :instance
      expect($ec2).to receive(:reboot_instances).with(instance_ids: [@i.instance_id])
      @i.reboot
    end
  end


  describe "terminate" do
    it "should call Amazon" do
      @i = create :instance
      expect($ec2).to receive(:terminate_instances).with(instance_ids: [@i.instance_id])
      @i.terminate
    end
  end

end
