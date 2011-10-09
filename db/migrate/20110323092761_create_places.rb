class CreatePlaces < ActiveRecord::Migration
  def self.up
    create_table :places do |t|
      t.string :name, :limit=>30
      t.datetime :deleted_at
      t.timestamps
  
      t.integer :lock_version, :default=>0
    end

end

  def self.down
    drop_table :places
  end
end