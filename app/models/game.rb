class Game < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :team1, :class_name => "Team"
  belongs_to :team2, :class_name => "Team"

  validates_presence_of :group
  validates_presence_of :place
  validates_presence_of :round
  validates_presence_of :start_at
  validate :presence_of_teams

  GROUP        = "group"
  QUARTERFINAL = "quarterfinal"
  SEMIFINAL    = "semifinal"
  FINAL        = "final"

  def team1
    if team1_id.present?
      self.team1
    else
      self.team1_placeholder_name
    end
  end

  def team2
    if team2_id.present?
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
