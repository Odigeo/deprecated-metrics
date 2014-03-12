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
  
    it "should have a state field" do
      create(:instance).state.should be_a String
    end
      
    it "should have an instance type field" do
      create(:instance).instance_type.should be_a String
    end
      
    it "should have an launch time field" do
      create(:instance).launch_time.should be_a Time
    end
      
    it "should have an availability zone field" do
      create(:instance).availability_zone.should be_a String
    end
      
    it "should have subnet_id field" do
      create(:instance).subnet_id.should be_a String
    end
      
    it "should have private_ip_address field" do
      create(:instance).private_ip_address.should be_a String
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
      $ec2.should_receive(:describe_instances).
        and_return(double('ec2_reply', reservations: [double('reservation', instances: [double('i', instance_id: "i-12345678")])]))
      Instance.should_receive(:refresh_from_struct).once
      Instance.refresh_all
    end

    it "should destroy instances not in the result set" do
      i1 = create :instance, instance_id: "i-11111111"
      i2 = create :instance, instance_id: "i-22222222"
      i3 = create :instance, instance_id: "i-33333333"
      i4 = create :instance, instance_id: "i-44444444"
      Instance.count.should == 4
      $ec2.should_receive(:describe_instances).
        and_return(double('ec2_reply', 
          reservations: [double('reservation-1', instances: [double('i3', instance_id: "i-33333333")]),
                         double('reservation-2', instances: [double('i1', instance_id: "i-11111111")])
                        ]))
      Instance.should_receive(:refresh_from_struct).twice
      Instance.refresh_all
      Instance.count.should == 2
      Instance.find_by_instance_id("i-11111111").should == i1
      Instance.find_by_instance_id("i-22222222").should == nil
      Instance.find_by_instance_id("i-33333333").should == i3
      Instance.find_by_instance_id("i-44444444").should == nil
    end
  end


  describe "refresh_from_struct" do

    it "should try to receive the instance from its id" do
      Instance.should_receive(:find_by_instance_id)
      Instance.refresh_from_struct({'tags' => {}, 'state' => {}, 'placement' => {}})
    end

    it "should create an instance if not found" do
      Instance.should_receive(:create!)
      Instance.refresh_from_struct({'instance_id' => 'UNKNOWN', 'tags' => {}, 'state' => {}, 'placement' => {}})
    end

    it "should update an instance if it already exists and is different" do
      create(:instance, instance_id: "i-12345678", contents: {})
      Instance.should_not_receive(:create!)
      Instance.any_instance.should_receive(:update_attributes)
      Instance.refresh_from_struct({'instance_id' => 'i-12345678', 'tags' => {}, 
                                    'state' => {}, 'placement' => {}})
    end

    it "should not update an instance if it already exists but is unchanged" do
      create(:instance, instance_id: "i-99999999", contents: {'instance_id' => 'i-99999999', 'tags' => {}, 
                                                              'state' => {}, 'placement' => {}})
      Instance.should_not_receive(:create!)
      Instance.any_instance.should_not_receive(:update_attributes)
      Instance.refresh_from_struct({'instance_id' => 'i-99999999', 'tags' => {}, 
                                    'state' => {}, 'placement' => {}})
    end
  end


  describe "start" do
    it "should take an optional string argument" do
      $ec2.should_receive(:start_instances).twice
      @i = create :instance
      @i.start("This is the reason for starting")
      Instance.delete_all
      @i = create :instance
      @i.start
    end

    it "should call Amazon" do
      @i = create :instance
      $ec2.should_receive(:start_instances).with(instance_ids: [@i.instance_id])
      @i.start
    end
  end


  describe "stop" do
    it "should call Amazon" do
      @i = create :instance
      $ec2.should_receive(:stop_instances).with(instance_ids: [@i.instance_id])
      @i.stop
    end
  end


  describe "reboot" do
    it "should call Amazon" do
      @i = create :instance
      $ec2.should_receive(:reboot_instances).with(instance_ids: [@i.instance_id])
      @i.reboot
    end
  end


  describe "terminate" do
    it "should call Amazon" do
      @i = create :instance
      $ec2.should_receive(:terminate_instances).with(instance_ids: [@i.instance_id])
      @i.terminate
    end
  end

end
