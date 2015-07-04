class RenamePunkteAndTipp < ActiveRecord::Migration
  def up
    remove_index :tipps, name: 'index_tipps_on_game_id'
    remove_index :tipps, name: 'index_tipps_on_user_id'

    rename_column :tipps, :tipp_punkte, :tip_points
    rename_table :tipps, :tips

    add_index :tips, :game_id, name: 'index_tips_on_game_id'
    add_index :tips, :user_id, name: 'index_tips_on_user_id'

    rename_column :users, :championtipppoints, :championtippoints
    rename_column :users, :championtipp_team_id, :championtip_team_id
  end

  def down
    # do nothing
  end
end
