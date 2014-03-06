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

class Instance < ActiveRecord::Base

  ocean_resource_model index: [:instance_id, :name, :chef_env, :service], 
                       search: false

  serialize :contents, JSON

  attr_accessible :instance_id, :name, :description, :chef_env, :service, :subservice, :contents,
                  :state, :instance_type, :launch_time, :availability_zone, :subnet_id, 
                  :private_ip_address


  def self.refresh_all
    response = $ec2.describe_instances  # (filters: [{name: "tag:ChefEnv", values: [CHEF_ENV]}])
    response.reservations.each do |reservation|
      reservation.instances.each do |instance|
        refresh_from_struct instance
      end
    end
    true
  end


  def self.refresh_from_struct(s)
    contents = JSON.parse(s.to_json)
    instance_id = contents['instance_id']
    tags = contents['tags'].inject({}) { |memo, h| memo[h['key']] = h['value']; memo }
    name = tags['Name']
    chef_env = tags['ChefEnv']
    service = tags['Service']
    subservice = tags['Subservice']
    state = contents['state']['name']
    instance_type = contents['instance_type']
    launch_time = contents['launch_time'] if contents['launch_time']
    availability_zone = contents['placement']['availability_zone']
    subnet_id = contents['subnet_id']
    private_ip_address = contents['private_ip_address']
    i = find_by_instance_id(instance_id)
    if !i
      create! instance_id: instance_id, name: name, description: "",
              chef_env: chef_env, service: service, subservice: subservice,
              contents: contents, state: state, instance_type: instance_type,
              launch_time: launch_time, availability_zone: availability_zone,
              subnet_id: subnet_id, private_ip_address: private_ip_address
    else
      #if true # contents.to_json != i.contents.to_json
        i.update_attributes name: name,
              chef_env: chef_env, service: service, subservice: subservice,
              contents: contents, state: state, instance_type: instance_type,
              launch_time: launch_time, availability_zone: availability_zone,
              subnet_id: subnet_id, private_ip_address: private_ip_address
      #end 
    end
  end

end
