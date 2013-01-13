# -*- encoding : utf-8 -*-
class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name, :limit=>30
      t.datetime :deleted_at
      t.timestamps
  
      t.integer :lock_version, :default=>0
    end


end

  def self.down
    drop_table :groups
  end
end
