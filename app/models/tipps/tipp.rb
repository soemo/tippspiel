# -*- encoding : utf-8 -*-
class Tipp < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :game
  belongs_to :user

  validates_presence_of :user
  validates_presence_of :game
  validates_presence_of :team1_goals, :unless => lambda{ |object| object.new_record? }
  validates_presence_of :team2_goals, :unless => lambda{ |object| object.new_record? }
  validates_numericality_of :team1_goals, :allow_nil => true, :on => :update, :greater_than_or_equal_to => 0
  validates_numericality_of :team2_goals, :allow_nil => true, :on => :update, :greater_than_or_equal_to => 0

  def edit_allowed?
    game.start_at > Time.now
  end
          # TODO soeren 30.04.15 move to Tipps::Save Service
  def remove_leading_zero
    if team1_goals.present?
      self.team1_goals = team1_goals.to_i
    end
    if team2_goals.present?
      self.team2_goals = team2_goals.to_i
    end
  end

end
