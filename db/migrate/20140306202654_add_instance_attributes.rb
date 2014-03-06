class AddInstanceAttributes < ActiveRecord::Migration

  def change
    add_column :instances, :state,              :string
    add_column :instances, :instance_type,      :string
    add_column :instances, :launch_time,        :datetime
    add_column :instances, :availability_zone,  :string
    add_column :instances, :subnet_id,          :string
    add_column :instances, :private_ip_address, :string
  end

end
