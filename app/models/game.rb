class Game < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :team1, :class_name => "Team"
  belongs_to :team2, :class_name => "Team"

  validates_presence_of :place
  validates_presence_of :round
  validates_presence_of :start_at
  validate :presence_of_teams

  GROUP        = "group"
  QUARTERFINAL = "quarterfinal"
  SEMIFINAL    = "semifinal"
  FINAL        = "final"

  default_scope order("start_at")

  scope :group_games,        where(:round => GROUP)
  scope :quarterfinal_games, where(:round => QUARTERFINAL)
  scope :semifinal_games,    where(:round => SEMIFINAL)
  scope :final_games,        where(:round => FINAL)

  def self.splited_by_rounds
    result = {}
    result[1] = {GROUP => Game.group_games}
    result[2] = {QUARTERFINAL => Game.quarterfinal_games}
    result[3] = {SEMIFINAL => Game.semifinal_games}
    result[4] = {FINAL => Game.final_games}

    result
  end

  def team1_view_name
    if self.team1_id.present?
      self.team1
    else
      self.team1_placeholder_name
    end
  end

  def team2_view_name
    if self.team2_id.present?
      self.team2
    else
      self.team2_placeholder_name
    end
  end

  protected

  def presence_of_teams
    unless(team1_id.present? || team1_placeholder_name.present?)
      errors.add_on_blank(:team1)
    end
    unless(team2_id.present? || team2_placeholder_name.present?)
      errors.add_on_blank(:team2)
    end
  end

end
