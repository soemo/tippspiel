class Tipp < ActiveRecord::Base

  belongs_to :game
  belongs_to :user

  validates_presence_of :user
  validates_presence_of :game
  validates_presence_of :team1_tore
  validates_presence_of :team2_tore

end
