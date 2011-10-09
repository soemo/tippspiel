class CreateTipp < ActiveRecord::Migration
  def self.up
    create_table :tipps do |t|
      t.integer :user_id
      t.integer :game_id
      t.integer :tipp_punkte
      t.string :team1_tore, :limit => 2
      t.string :team2_tore, :limit => 2
      t.datetime :deleted_at
      t.timestamps
  
      t.integer :lock_version, :default=>0
    end

end

  def self.down
    drop_table :tipps
  end
end