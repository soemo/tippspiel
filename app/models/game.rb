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

  ROUNDS = [GROUP, QUARTERFINAL, SEMIFINAL, FINAL]

  UNENTSCHIEDEN = 0
  TEAM1_WIN     = 1
  TEAM2_WIN     = 2

  default_scope order("start_at")

  scope :group_games,        where(:round => GROUP)
  scope :quarterfinal_games, where(:round => QUARTERFINAL)
  scope :semifinal_games,    where(:round => SEMIFINAL)
  scope :final_games,        where(:round => FINAL)

  def self.today_games
    #Game.where(:start_at => [Time.now.midnight...Time.now.midnight+1.day]).all
    Game.where(:start_at => ['2012-06-7 22:00:00'...'2012-06-8 22:00:00']).all
  end

  def self.splited_by_rounds
    result = {}
    result[1] = {GROUP => Game.group_games}
    result[2] = {QUARTERFINAL => Game.quarterfinal_games}
    result[3] = {SEMIFINAL => Game.semifinal_games}
    result[4] = {FINAL => Game.final_games}

    result
  end

  def self.round_start_end_date_time(round)
    games = Game.where(:round => round).order("start_at asc").select("start_at")
    start_date_time = games.first.start_at
    end_date_time = games.last.start_at

    [start_date_time, end_date_time]
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

  # wer hat gewonnen Team1 oder Team2, unentschieden == 0
  def winner
    result = nil
    if team1_goals.present? && team2_goals.present?
      result = TEAM1_WIN if team1_goals > team2_goals
      result = TEAM2_WIN if team1_goals < team2_goals
      result = UNENTSCHIEDEN if team1_goals == team2_goals
    end

    result
  end

  # bei Unentschieden wird nil geliefert ansonsten, das Siegerteam
  def winner_team
    result = nil
    if team1_goals.present? && team2_goals.present?
      result = team1 if team1_goals > team2_goals
      result = team2 if team1_goals < team2_goals
    end

    result
  end

  def self.tournament_finished?
    result = false
    games = Game.final_games
    if games.present?
      result = games.first.finished?
    end

    result
  end

  def self.before_tournament?
    result = true
    first_game = Game.order("start_at asc").first
    if first_game.present? && first_game.start_at < Time.now
      result = false
    end
    result
  end

  def self.tournament_champion_team
    result = nil
    games = Game.final_games
    if games.present?
      result = games.first.winner_team
    end

    result
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
