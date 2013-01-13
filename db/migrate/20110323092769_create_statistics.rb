# -*- encoding : utf-8 -*-
class CreateStatistics < ActiveRecord::Migration
  def self.up
    create_table :statistics do |t|
      t.integer :user_id
      t.integer :position
      t.integer :day_id
      t.datetime :deleted_at
      t.timestamps
  
      t.integer :lock_version, :default=>0
    end

end

  def self.down
    drop_table :statistics
  end
end
