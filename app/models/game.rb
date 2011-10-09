class Game < ActiveRecord::Base

  belongs_to :day
  belongs_to :group
  belongs_to :place
  belongs_to :round
  belongs_to :starttime
  belongs_to :team1, :class_name => "Team"
  belongs_to :team2, :class_name => "Team"

  validates_presence_of :day
  validates_presence_of :group
  validates_presence_of :place
  validates_presence_of :round
  validates_presence_of :starttime
  validates_presence_of :team1
  validates_presence_of :team2

end
