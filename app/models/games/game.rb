# -*- encoding : utf-8 -*-
class Game < ActiveRecord::Base
  acts_as_paranoid

  include WmConfig if IS_WM
  include EmConfig if IS_EM

  belongs_to :team1, :class_name => 'Team'
  belongs_to :team2, :class_name => 'Team'
  has_many   :tips

  validates_presence_of :place
  validates_presence_of :round
  validates_presence_of :start_at
  validates_presence_of :api_match_id
  validates_uniqueness_of :api_match_id
  validate :presence_of_teams

  default_scope { order(start_at: :asc) }   # FIXME soeren 29.04.15 entfernen und besser machen

  scope :finished, -> { where(:finished => true) }   # TODO soeren 30.04.15 in GameQueries

  scope :group_games,       -> { where(:round => GROUP) }     # TODO soeren 30.04.15 in GameQueries
  scope :final_games,       -> { where(:round => FINAL) }     # TODO soeren 30.04.15 in GameQueries

  # TODO soeren 30.04.15 in einen Presenter auslagern
  def to_s
    "#{I18n.l(start_at, :format => :default)}:  #{team1_view_name} - #{team2_view_name}"
  end

         # TODO soeren 30.04.15 in application_helper
  def team1_view_name
    if self.team1_id.present?
      self.team1.to_s
    else
      self.team1_placeholder_name
    end
  end
  # TODO soeren 30.04.15 in application_helper
  def team2_view_name
    if self.team2_id.present?
      self.team2.to_s
    else
      self.team2_placeholder_name
    end
  end
  # TODO soeren 30.04.15 in application_helper
  def team1_country_code
    self.team1_id.present? ? team1.country_code : ''
  end
  # TODO soeren 30.04.15 in application_helper
  def team2_country_code
    self.team2_id.present? ? team2.country_code : ''
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
