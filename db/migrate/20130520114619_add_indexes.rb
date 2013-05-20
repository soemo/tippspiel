class AddIndexes < ActiveRecord::Migration
  def up
    add_index :games, :team1_id, :name => 'index_games_on_team1_id'
    add_index :games, :team2_id, :name => 'index_games_on_team2_id'
    add_index :games, :api_match_id, :name => 'index_games_on_api_match_id'

    add_index :notices, :user_id, :name => 'index_notices_on_user_id'

    add_index :statistics, :user_id, :name => 'index_statistics_on_user_id'

    add_index :tipps, :user_id, :name => 'index_tipps_on_user_id'
    add_index :tipps, :game_id, :name => 'index_tipps_on_game_id'
  end

  def down
    remove_index :games, :name => 'index_games_on_team1_id'
    remove_index :games, :name => 'index_games_on_team2_id'
    remove_index :games, :name => 'index_games_on_api_match_id'

    remove_index :notices, :name => 'index_notices_on_user_id'

    remove_index :statistics, :name => 'index_statistics_on_user_id'

    remove_index :tipps, :name => 'index_tipps_on_user_id'
    remove_index :tipps, :name => 'index_tipps_on_game_id'
  end
end
