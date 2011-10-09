class CreateStarttimes < ActiveRecord::Migration
  def self.up
    create_table :starttimes do |t|
      t.time :name
      t.datetime :deleted_at
      t.timestamps
  
      t.integer :lock_version, :default=>0
    end

end

  def self.down
    drop_table :starttimes
  end
end