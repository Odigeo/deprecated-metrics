class MakeContentsText < ActiveRecord::Migration

  def change
    change_column :instances, :contents, :text, limit: nil
  end

end
