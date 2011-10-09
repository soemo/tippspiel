class CreateRounds < ActiveRecord::Migration
  def self.up
    create_table :rounds do |t|
      t.integer :start_day_id
      t.integer :end_day_id
      t.string :name, :limit=>30
      t.datetime :deleted_at
      t.timestamps
  
      t.integer :lock_version, :default=>0
    end

end

  def self.down
    drop_table :rounds
  end
end