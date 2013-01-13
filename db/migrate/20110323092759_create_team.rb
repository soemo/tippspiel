# -*- encoding : utf-8 -*-
class CreateTeam < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.string :flag_image_url
      t.string :name, :limit=>30
      t.datetime :deleted_at
      t.timestamps
  
      t.integer :lock_version, :default=>0
    end

end

  def self.down
    drop_table :teams
  end
end
