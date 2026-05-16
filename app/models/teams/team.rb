class Team < ApplicationRecord
  acts_as_paranoid

  validates_presence_of :name
  # football_data_tla is optional (nil for not-yet-mapped teams) but must be
  # unique when present — duplicates would silently misroute imported matches.
  validates :football_data_tla, uniqueness: true, allow_nil: true

end
