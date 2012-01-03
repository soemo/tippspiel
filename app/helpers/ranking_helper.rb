module RankingHelper

  # bekommt eine Liste von Usern,
  # sortiert nach Gesamtpounten, Anzahl6Punkte,Anzahl4Punkte und Anzahl3Punkte
  # geliefert
  # Es wird noch die Platzierung als Key hinzugefuegt
  def prepare_user_ranking(ranking_users)
    # TODO soeren 03.01.12 Cache
    result = {}
    if ranking_users.present?
      place = 1
      last_used_user = nil
      ranking_users.each do |u|
        if last_used_user.nil?
          # erste User
          result[place] = [u]
        else
          if last_used_user.ranking_comparison_value > u.ranking_comparison_value
            place = place + 1
            result[place] = u
          elsif last_used_user.ranking_comparison_value == u.ranking_comparison_value
            same_place_users = result[place]
            result[place] = same_place_users + [u]
          else
            # no else
          end
        end
        last_used_user = u
      end
    end

    result
  end

end
