class CreateInstances < ActiveRecord::Migration
  def change
    create_table :instances do |t|
      t.string :instance_id
      t.string :name
      t.string :description
      t.string :chef_env
      t.string :service
      t.string :subservice
      t.string :contents

      t.timestamps
      t.integer :lock_version, null: false, default: 0
    end
  end
end
