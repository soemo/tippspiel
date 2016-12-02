class Game < ApplicationRecord
  acts_as_paranoid

  belongs_to :team1, :class_name => 'Team'
  belongs_to :team2, :class_name => 'Team'
  has_many   :tips

  validates_presence_of :place
  validates_presence_of :round
  validates_presence_of :start_at
  validate :presence_of_teams

  def started?
    start_at <= DateTime.now
  end

  def today?
    start_at.to_date == Date.today
  end

  private

  def presence_of_teams
    unless team1_id.present? || team1_placeholder_name.present?
      errors.add(:team1_id, :blank)
    end
    unless team2_id.present? || team2_placeholder_name.present?
      errors.add(:team2_id, :blank)
    end
  end

end
