# -*- encoding : utf-8 -*-
class GetTodayGames

  include BaseService

  def call
    today_games
  end

  private

  # Es werden die Spiele einschliesslich 00:00 bis 24:00
  # des Tages geliefert
  def today_games
    t = Time.now.midnight
    Game.where(:start_at => [t..t+1.day])
  end

end