class RemovePolls < ActiveRecord::Migration
  def up
    drop_table :polls
    remove_column :users, :poll_id
  end

  def down
    # nothing
  end
end
