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

class Instance < ActiveRecord::Base

  ocean_resource_model index: [:instance_id, :name, :chef_env, :service, :subservice], 
                       search: false


  # Relations


  # Attributes


  # Validations
  
  
end
