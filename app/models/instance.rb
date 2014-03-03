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

class Instance < ActiveRecord::Base

  ocean_resource_model index: [:instance_id, :name, :chef_env, :service], 
                       search: false

  serialize :contents, JSON

  attr_accessible :instance_id, :name, :description, :chef_env, :service, :subservice, :contents


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
    i = find_by_instance_id(instance_id)
    if !i
      create! instance_id: instance_id, name: name, description: "",
              chef_env: chef_env, service: service, subservice: subservice,
              contents: contents
    else
      if contents.to_json != i.contents.to_json
        i.update_attributes instance_id: instance_id, name: name, description: "",
              chef_env: chef_env, service: service, subservice: subservice,
              contents: contents
      end 
    end
  end

end
