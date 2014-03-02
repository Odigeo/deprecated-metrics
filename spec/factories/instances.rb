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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :instance do
    instance_id "i-#{Random.rand(99999999)}"
    name "MyString"
    description "MyString"
    chef_env "master"
    service "auth"
    subservice "something"
    contents "{}"
  end
end
