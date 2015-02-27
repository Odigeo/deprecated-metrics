require 'spec_helper'

describe "instances/_instance" do

  describe "representations" do
  
    before :each do                     # Must be :each (:all causes all tests to fail)
      render partial: "instances/instance", locals: {instance: create(:instance, contents: {})}
      @json = JSON.parse(rendered)
      @u = @json['instance']
      @links = @u['_links'] rescue {}
    end

    it "has a named root" do
      expect(@u).not_to eq(nil)
    end

    it "should have a name" do
      expect(@u['name']).to be_a String
    end

    it "should have a description" do
      expect(@u['description']).to be_a String
    end

    it "should have a created_at time" do
      expect(@u['created_at']).to be_a String
    end

    it "should have an updated_at time" do
      expect(@u['updated_at']).to be_a String
    end

    it "should have a lock_version field" do
      expect(@u['lock_version']).to be_an Integer
    end
        
    it "should have a instance_id field" do
      expect(@u['instance_id']).to be_a String
    end
        
    it "should have a chef_env field" do
      expect(@u['chef_env']).to be_a String
    end
        
    it "should have a service field" do
      expect(@u['service']).to be_a String
    end
        
    it "should have a subservice field" do
      expect(@u['subservice']).to be_a String
    end
        
    it "should NOT have a contents field" do
      expect(@u['contents']).to eq(nil)
    end
        
    it "should have a state field" do
      expect(@u['state']).to be_a String
    end
        
    it "should have an instance type field" do
      expect(@u['instance_type']).to be_a String
    end
        
    it "should have an launch time field" do
      expect(@u['launch_time']).to be_a String
    end
        
    it "should have an availability zone field" do
      expect(@u['availability_zone']).to be_a String
    end
        
    it "should have subnet_id field" do
      expect(@u['subnet_id']).to be_a String
    end
        
    it "should have private_ip_address field" do
      expect(@u['private_ip_address']).to be_a String
    end
  end


  describe "stopped instances" do

    before :each do                     # Must be :each (:all causes all tests to fail)
      render partial: "instances/instance", locals: {instance: create(:instance, state: "stopped", contents: {})}
      @json = JSON.parse(rendered)
      @u = @json['instance']
      @links = @u['_links'] rescue {}
    end

    it "should have a self hyperlink" do
      expect(@links).to be_hyperlinked('self', /instances/)
    end

    it "should use an id of the form i-99999999 in the self hyperlink" do
      expect(@links['self']['href'].split('/')[-1]).to match /i-[0-9]+/
    end

    it "should have a terminate hyperlink" do
      expect(@links).to be_hyperlinked('terminate', /instances/)
    end

    it "should have a start hyperlink" do
      expect(@links).to be_hyperlinked('start', /instances/)
    end
  end


  describe "running instances" do

    before :each do                     # Must be :each (:all causes all tests to fail)
      render partial: "instances/instance", locals: {instance: create(:instance, state: "running", contents: {})}
      @json = JSON.parse(rendered)
      @u = @json['instance']
      @links = @u['_links'] rescue {}
    end

    it "should have a self hyperlink" do
      expect(@links).to be_hyperlinked('self', /instances/)
    end

    it "should use an id of the form i-99999999 in the self hyperlink" do
      expect(@links['self']['href'].split('/')[-1]).to match /i-[0-9]+/
    end

    it "should have a stop hyperlink" do
      expect(@links).to be_hyperlinked('stop', /instances/)
    end

    it "should have a reboot hyperlink" do
      expect(@links).to be_hyperlinked('reboot', /instances/)
    end
  end

end
