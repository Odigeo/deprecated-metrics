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
      @u.should_not == nil
    end

    it "should have a name" do
      @u['name'].should be_a String
    end

    it "should have a description" do
      @u['description'].should be_a String
    end

    it "should have a created_at time" do
      @u['created_at'].should be_a String
    end

    it "should have an updated_at time" do
      @u['updated_at'].should be_a String
    end

    it "should have a lock_version field" do
      @u['lock_version'].should be_an Integer
    end
        
    it "should have a instance_id field" do
      @u['instance_id'].should be_a String
    end
        
    it "should have a chef_env field" do
      @u['chef_env'].should be_a String
    end
        
    it "should have a service field" do
      @u['service'].should be_a String
    end
        
    it "should have a subservice field" do
      @u['subservice'].should be_a String
    end
        
    it "should have a contents field" do
      @u['contents'].should_not == nil
    end
        
    it "should have a state field" do
      @u['state'].should be_a String
    end
        
    it "should have an instance type field" do
      @u['instance_type'].should be_a String
    end
        
    it "should have an launch time field" do
      @u['launch_time'].should be_a String
    end
        
    it "should have an availability zone field" do
      @u['availability_zone'].should be_a String
    end
        
    it "should have subnet_id field" do
      @u['subnet_id'].should be_a String
    end
        
    it "should have private_ip_address field" do
      @u['private_ip_address'].should be_a String
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
      @links.should be_hyperlinked('self', /instances/)
    end

    it "should use an id of the form i-99999999 in the self hyperlink" do
      @links['self']['href'].split('/')[-1].should match /i-[0-9]+/
    end

    it "should have a terminate hyperlink if stopped" do
      @links.should be_hyperlinked('terminate', /instances/)
    end

    it "should have a start hyperlink if stopped" do
      @links.should be_hyperlinked('start', /instances/)
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
      @links.should be_hyperlinked('self', /instances/)
    end

    it "should use an id of the form i-99999999 in the self hyperlink" do
      @links['self']['href'].split('/')[-1].should match /i-[0-9]+/
    end

    it "should have a stop hyperlink if running" do
      @links.should be_hyperlinked('stop', /instances/)
    end

    it "should have a reboot hyperlink if running" do
      @links.should be_hyperlinked('reboot', /instances/)
    end
  end

end
