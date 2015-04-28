# -*- encoding : utf-8 -*-
class Game < ActiveRecord::Base
  acts_as_paranoid

  include WmConfig if IS_WM
  include EmConfig if IS_EM

  belongs_to :team1, :class_name => 'Team'
  belongs_to :team2, :class_name => 'Team'
  has_many   :tipps

  validates_presence_of :place
  validates_presence_of :round
  validates_presence_of :start_at
  validates_presence_of :api_match_id
  validates_uniqueness_of :api_match_id
  validate :presence_of_teams

  UNENTSCHIEDEN = 0
  TEAM1_WIN     = 1
  TEAM2_WIN     = 2

  default_scope { order('start_at') }

  scope :finished_games,    -> { where(:finished => true) }

  scope :group_games,       -> { where(:round => GROUP) }
  scope :final_games,       -> { where(:round => FINAL) }

  def self.last_updated_at
    Game.unscoped.maximum('updated_at')
  end

  def to_s
    "#{I18n.l(start_at, :format => :default)}:  #{team1_view_name} - #{team2_view_name}"
  end

  def self.round_start_end_date_time(round)
    games = Game.where(:round => round).order('start_at asc').select('start_at')
    if games.present?
      start_date_time = games.first.start_at
      end_date_time   = games.last.start_at
    else
      start_date_time = end_date_time = nil
    end

    [start_date_time, end_date_time]
  end

  # Spieltage holen an dennen alle Spiele beendet sind
  def self.finished_days_with_game_ids
    game_days_with_game_ids = {}
    not_finished_days = []
    Game.select('id, start_at, finished').each do |game|
      key = game.start_at.to_date.to_s
      if game.finished == false
        # Spiele diesen Tages aus game_days_with_game_ids wieder entfernen
        game_days_with_game_ids = game_days_with_game_ids.delete_if{|k,_| k == key}
        # und als nicht fertigen Tag kennzeichnen
        not_finished_days << key
      end
      unless not_finished_days.include?(key)
        if game_days_with_game_ids.has_key?(key)
          game_days_with_game_ids[key] = game_days_with_game_ids[key] + [game.id]
        else
          game_days_with_game_ids[key] = [game.id]
        end
      end
    end

    game_days_with_game_ids
  end

  def team1_view_name
    if self.team1_id.present?
      self.team1.to_s
    else
      self.team1_placeholder_name
    end
  end

  def team2_view_name
    if self.team2_id.present?
      self.team2.to_s
    else
      self.team2_placeholder_name
    end
  end

  def team1_country_code
    self.team1_id.present? ? team1.country_code : ''
  end

  def team2_country_code
    self.team2_id.present? ? team2.country_code : ''
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

  # Wenn das Finale als beendet markiert ist
  def self.tournament_finished?
    result = false
    games = Game.final_games
    if games.present?
      result = games.first.finished?
    end

    result
  end

  def self.first_game_in_tournament
    Game.order('start_at asc').first
  end

  def self.before_tournament?
    result = true
    first_game = Game.first_game_in_tournament
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
    unless team1_id.present? || team1_placeholder_name.present?
      errors.add_on_blank(:team1)
    end
    unless team2_id.present? || team2_placeholder_name.present?
      errors.add_on_blank(:team2)
    end
  end

end
