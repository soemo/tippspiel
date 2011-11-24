class DeleteGameAttrs < ActiveRecord::Migration
  def up
    remove_column :games, :group_id
    remove_column :games, :place_id
    remove_column :games, :round_id
    remove_column :games, :day_id
    remove_column :games, :starttime_id
  end

  def down
    # nothing to do
  end
end
