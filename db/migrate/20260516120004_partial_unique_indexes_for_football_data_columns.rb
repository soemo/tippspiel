class PartialUniqueIndexesForFootballDataColumns < ActiveRecord::Migration[6.1]
  # Replaces the plain unique indexes added in 20260516120000 (games) and
  # 20260516120003 (teams) with partial unique indexes scoped to non-deleted
  # rows.  This aligns DB constraints with acts_as_paranoid soft-delete
  # semantics: a soft-deleted record no longer blocks reuse of the same
  # football_data_match_id or football_data_tla.

  def up
    # games.football_data_match_id
    remove_index :games, :football_data_match_id
    add_index :games, :football_data_match_id, unique: true,
              where: 'deleted_at IS NULL',
              name: 'index_games_on_football_data_match_id_not_deleted'

    # teams.football_data_tla
    remove_index :teams, :football_data_tla
    add_index :teams, :football_data_tla, unique: true,
              where: 'deleted_at IS NULL',
              name: 'index_teams_on_football_data_tla_not_deleted'
  end

  def down
    remove_index :games, name: 'index_games_on_football_data_match_id_not_deleted'
    add_index :games, :football_data_match_id, unique: true

    remove_index :teams, name: 'index_teams_on_football_data_tla_not_deleted'
    add_index :teams, :football_data_tla, unique: true
  end
end
