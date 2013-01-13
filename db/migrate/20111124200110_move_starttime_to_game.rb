# -*- encoding : utf-8 -*-
class MoveStarttimeToGame < ActiveRecord::Migration
  def up
    drop_table :starttimes
    add_column :games, :start_at, :datetime
  end

  def down
  end
end
