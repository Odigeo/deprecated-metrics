class MakeInstanceIdUnique < ActiveRecord::Migration

  def change
    remove_index :instances, :instance_id
    add_index :instances, :instance_id, unique: true
  end

end
