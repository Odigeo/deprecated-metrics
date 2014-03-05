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

require 'spec_helper'

describe "instances/_instance" do
  
  before :each do                     # Must be :each (:all causes all tests to fail)
    render partial: "instances/instance", locals: {instance: create(:instance, contents: {})}
    @json = JSON.parse(rendered)
    @u = @json['instance']
    @links = @u['_links'] rescue {}
  end


  it "has a named root" do
    @u.should_not == nil
  end


  it "should have one hyperlink" do
    @links.size.should == 1
  end

  it "should have a self hyperlink" do
    @links.should be_hyperlinked('self', /instances/)
  end

  it "should use an id of the form i-99999999 in the self hyperlink" do
    @links['self']['href'].split('/')[-1].should match /i-[0-9]+/
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
      
end
