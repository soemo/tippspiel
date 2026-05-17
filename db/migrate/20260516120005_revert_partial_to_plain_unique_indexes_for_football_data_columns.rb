# frozen_string_literal: true

class RevertPartialToPlainUniqueIndexesForFootballDataColumns < ActiveRecord::Migration[6.1]
  # MySQL does not support partial (WHERE-clause) indexes.  Migration
  # 20260516120004 attempted to add partial unique indexes but they were
  # silently created as plain unique indexes instead, making the migration
  # name and comments misleading.  This migration replaces them with
  # explicitly-named plain unique indexes and is the canonical constraint.
  #
  # Soft-delete caveat: in practice neither teams nor games are ever hard-
  # deleted or have their TLA/match-id reused after soft-deletion, so a
  # plain unique index is safe here.  If that assumption changes, a
  # generated-column or application-level nulling strategy would be needed.

  def up
    remove_index :games, name: 'index_games_on_football_data_match_id_not_deleted'
    add_index :games, :football_data_match_id, unique: true

    remove_index :teams, name: 'index_teams_on_football_data_tla_not_deleted'
    add_index :teams, :football_data_tla, unique: true
  end

  def down
    remove_index :games, :football_data_match_id
    add_index :games, :football_data_match_id, unique: true,
                                               where: 'deleted_at IS NULL',
                                               name: 'index_games_on_football_data_match_id_not_deleted'

    remove_index :teams, :football_data_tla
    add_index :teams, :football_data_tla, unique: true,
                                          where: 'deleted_at IS NULL',
                                          name: 'index_teams_on_football_data_tla_not_deleted'
  end
end
