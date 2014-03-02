require 'spec_helper'

describe "instances/_instance" do
  
  before :each do                     # Must be :each (:all causes all tests to fail)
    render partial: "instances/instance", locals: {instance: create(:instance)}
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
      
end
