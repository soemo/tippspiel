class RemoveEventsTable < ActiveRecord::Migration
  def up
    drop_table :events
  end

  def down
    # do nothing
  end
end
