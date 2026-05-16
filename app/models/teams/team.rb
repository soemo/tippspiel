class Team < ApplicationRecord
  acts_as_paranoid

  validates_presence_of :name
  # football_data_tla is optional (nil for not-yet-mapped teams) but must be
  # unique among non-deleted teams when present — duplicates would silently
  # misroute imported matches.  Scoped to deleted_at: nil so soft-deleted rows
  # do not block re-use of a TLA (matches the partial DB index below).
  validates :football_data_tla, uniqueness: { conditions: -> { where(deleted_at: nil) } }, allow_nil: true

end
