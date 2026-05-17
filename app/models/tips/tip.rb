# frozen_string_literal: true

class Tip < ApplicationRecord
  acts_as_paranoid

  belongs_to :game
  belongs_to :user

  validates :team1_goals, presence: { unless: ->(object) { object.new_record? } }
  validates :team2_goals, presence: { unless: ->(object) { object.new_record? } }
  validates :team1_goals, numericality: { allow_nil: true, on: :update, greater_than_or_equal_to: 0 }
  validates :team2_goals, numericality: { allow_nil: true, on: :update, greater_than_or_equal_to: 0 }

  def edit_allowed?
    !game.started?
  end

  def remove_leading_zero
    self.team1_goals = team1_goals.to_i if team1_goals.present?
    return if team2_goals.blank?

    self.team2_goals = team2_goals.to_i
  end
end
