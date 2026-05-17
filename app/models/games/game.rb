# frozen_string_literal: true

class Game < ApplicationRecord
  acts_as_paranoid

  belongs_to :team1, class_name: 'Team', optional: true
  belongs_to :team2, class_name: 'Team', optional: true
  has_many   :tips, dependent: :destroy

  validates :place, presence: true
  validates :round, presence: true
  validates :start_at, presence: true
  validate :presence_of_teams

  def started?
    start_at <= DateTime.now
  end

  def today?
    start_at.to_date == Time.zone.today
  end

  private

  def presence_of_teams
    errors.add(:team1_id, :blank) unless team1_id.present? || team1_placeholder_name.present?
    return if team2_id.present? || team2_placeholder_name.present?

    errors.add(:team2_id, :blank)
  end
end
