# frozen_string_literal: true

# Canonical point values awarded per tip.
# These constants are the single source of truth used by scoring services,
# ranking calculation, and query helpers.
module TipPoints
  PERFECT                = 8  # exact score for both teams
  CORRECT_GOALS_ONE_TEAM = 5  # correct trend + exact goals for one team
  CORRECT_GOALS          = 4  # correct trend + correct goal difference
  CORRECT_TREND          = 3  # correct winner / draw only
  NO_POINTS              = 0  # wrong or missing tip

  BONUS = 8 # points awarded per correct bonus question answer

  ALL_VALUES = [PERFECT, CORRECT_GOALS_ONE_TEAM, CORRECT_GOALS, CORRECT_TREND, NO_POINTS].freeze
end
