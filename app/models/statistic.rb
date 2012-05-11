class Statistic < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :user

  validates_presence_of :user
  validates_presence_of :date_on
  validates_presence_of :position

  # Berechnet uns speichert die Statistik (User Platzierung am Spieltagsende)
  def self.calculate


    game_days_with_game_ids = Game.finished_days_with_game_ids
    if game_days_with_game_ids.present?
      game_days_with_game_ids.each do |day, game_ids|
         # FIXME soeren 10.05.12 besser umsetzen siehe Zettel
            #each darüber
    #  Userranking von diesem Spieltag holen
    #  Save Platzierung, user_id, date_on
    #end
      end
    end


  end

end
