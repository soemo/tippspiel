# frozen_string_literal: true

class AppSetting < ApplicationRecord
  BONUS_HOW_MANY_GOALS_KEY        = 'bonus_answer_how_many_goals'
  BONUS_WHEN_FIRST_GOAL_KEY       = 'bonus_answer_when_will_the_first_goal'

  validates :key, presence: true, uniqueness: true

  # Returns Integer or nil
  def self.bonus_answer_how_many_goals
    value = find_by(key: BONUS_HOW_MANY_GOALS_KEY)&.value
    value.presence&.to_i
  end

  # Returns Integer or nil
  def self.bonus_answer_when_will_the_first_goal
    value = find_by(key: BONUS_WHEN_FIRST_GOAL_KEY)&.value
    value.presence&.to_i
  end

  def self.set_bonus_answer_how_many_goals(val) # rubocop:disable Naming/AccessorMethodName -- intentional key-value store API naming
    upsert_value(BONUS_HOW_MANY_GOALS_KEY, val.presence)
  end

  def self.set_bonus_answer_when_will_the_first_goal(val) # rubocop:disable Naming/AccessorMethodName -- intentional key-value store API naming
    upsert_value(BONUS_WHEN_FIRST_GOAL_KEY, val.presence)
  end

  def self.upsert_value(key, value)
    record = find_or_initialize_by(key: key)
    record.value = value.to_s.presence
    record.save!
    record
  end
  private_class_method :upsert_value
end
