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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :instance do
    instance_id "i-#{Random.rand(99999999)}"
    name "MyString"
    description "MyString"
    chef_env "master"
    service "auth"
    subservice "something"
    contents nil
    state "running"
    instance_type "m1.medium"
    launch_time 1.month.ago
    availability_zone "eu-west-1b"
    subnet_id "7364gfdkf"
    private_ip_address "10.10.10.10"
  end
end
