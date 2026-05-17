# frozen_string_literal: true

class Team < ApplicationRecord
  acts_as_paranoid

  validates :name, presence: true
  # football_data_tla is optional (nil for not-yet-mapped teams) but must be
  # unique when present — duplicates would silently misroute imported matches.
  # MySQL does not support partial indexes so the DB constraint is a plain
  # unique index; soft-deleted rows are excluded from the default scope
  # (acts_as_paranoid) so uniqueness conflicts with deleted records are
  # unlikely in practice.
  validates :football_data_tla, uniqueness: true, allow_nil: true
end
