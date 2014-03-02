class AddInstanceIndices < ActiveRecord::Migration

  def change
    add_index :instances, :instance_id
    add_index :instances, [:chef_env, :name]
    add_index :instances, [:chef_env, :service]
  end

end
