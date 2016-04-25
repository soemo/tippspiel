class RemoveApiMatchIdFromGames < ActiveRecord::Migration
  def up
    remove_index :games, :name => 'index_games_on_api_match_id'
    remove_column :games, :api_match_id
  end

  def down
    # do nothing
  end
end
