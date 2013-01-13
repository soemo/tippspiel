# -*- encoding : utf-8 -*-
class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.integer :group_id
      t.integer :place_id
      t.integer :round_id
      t.integer :day_id
      t.integer :starttime_id
      t.integer :team1_id
      t.string :team1_tore, :limit => 2
      t.integer :team2_id
      t.string :team2_tore, :limit => 2
      t.datetime :deleted_at
      t.timestamps
  
      t.integer :lock_version, :default=>0
    end

end

  def self.down
    drop_table :games
  end
end
