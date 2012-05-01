class CreateEventTable < ActiveRecord::Migration
  def up
    create_table "events", :force => true do |t|
      t.string   "event_type", :limit => 30, :default => "", :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def down
    drop_table :events
  end
end
