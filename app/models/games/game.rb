# -*- encoding : utf-8 -*-
class Game < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :team1, :class_name => 'Team'
  belongs_to :team2, :class_name => 'Team'
  has_many   :tips

  validates_presence_of :place
  validates_presence_of :round
  validates_presence_of :start_at
  validate :presence_of_teams

  private

  def presence_of_teams
    unless team1_id.present? || team1_placeholder_name.present?
      errors.add_on_blank(:team1_id)
    end
    unless team2_id.present? || team2_placeholder_name.present?
      errors.add_on_blank(:team2_id)
    end
  end

end
