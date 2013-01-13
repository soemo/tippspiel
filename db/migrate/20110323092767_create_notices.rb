# -*- encoding : utf-8 -*-
class CreateNotices < ActiveRecord::Migration
  def self.up
    create_table :notices do |t|
      t.integer :user_id
      t.string :text, :limit=>200
      t.datetime :deleted_at
      t.timestamps
  
      t.integer :lock_version, :default=>0
    end

end

  def self.down
    drop_table :notices
  end
end
