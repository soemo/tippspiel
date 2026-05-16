# Tightens up two columns introduced in the football-data integration:
#
#   - teams.football_data_tla: replace the plain index with a unique index, so
#     a duplicate seed run (or any future bug) fails loudly rather than
#     silently misrouting matches to whichever team Team.find_by returns first.
#
#   - games.football_data_match_id: widen to :bigint. FD ids are currently in
#     the ~6-digit range, so this isn't urgent, but :bigint costs nothing on
#     MySQL and removes a long-term overflow concern.
class TightenFootballDataColumns < ActiveRecord::Migration[6.1]

  def up
    # Defensive: refuse to apply if duplicate TLAs are present. The seed map
    # is validated as unique by spec, but in production we want a hard guard
    # before adding the constraint.
    duplicates = Team.where.not(football_data_tla: nil)
                     .group(:football_data_tla)
                     .having('COUNT(*) > 1')
                     .pluck(:football_data_tla)
    if duplicates.any?
      raise "Cannot add unique index — duplicate football_data_tla values found: #{duplicates.inspect}"
    end

    remove_index :teams, :football_data_tla
    add_index    :teams, :football_data_tla, unique: true

    change_column :games, :football_data_match_id, :bigint
  end

  def down
    change_column :games, :football_data_match_id, :integer

    remove_index :teams, :football_data_tla
    add_index    :teams, :football_data_tla
  end

end
