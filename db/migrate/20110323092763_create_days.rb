class CreateDays < ActiveRecord::Migration
  def self.up
    create_table :days do |t|
      t.date :name
      t.datetime :deleted_at
      t.timestamps
  
      t.integer :lock_version, :default=>0
    end

end

  def self.down
    drop_table :days
  end
end