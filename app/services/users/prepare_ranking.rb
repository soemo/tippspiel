# -*- encoding : utf-8 -*-
module Users
  class PrepareRanking < UserBaseService

    attribute :users_for_ranking, Array[User]

    # bekommt eine Liste von Usern
    # sortiert nach Gesamtpunkten, Anzahl6Punkte, Anzahl4Punkte und Anzahl3Punkte geliefert
    # Es wird noch die Platzierung als Key hinzugefuegt
    # (wenn 3 Leute erster sind, ist der nächste dann auf Platz 4)
    # ACHTUNG DER HASH IST NICHT SORTIERT !!!!
    def call
      result = {}

      if users_for_ranking.present?
        place                    = 1
        user_count_on_same_place = 1
        last_used_user           = nil

        users_for_ranking.each do |u|
          if last_used_user.nil?
            # erste User
            result[place] = [u]
          else
            user_ranking_comparison_value = ranking_comparison_value(u.points,
                                                                     u.count8points,
                                                                     u.count5points,
                                                                     u.count4points,
                                                                     u.count3points)
            last_used_user_ranking_comparison_value = ranking_comparison_value(last_used_user.points,
                                                                               last_used_user.count8points,
                                                                               last_used_user.count5points,
                                                                               last_used_user.count4points,
                                                                               last_used_user.count3points)
            if last_used_user_ranking_comparison_value > user_ranking_comparison_value
              place = place + user_count_on_same_place
              result[place] = [u]
              user_count_on_same_place = 1
            elsif last_used_user_ranking_comparison_value == user_ranking_comparison_value
              same_place_users = result[place]
              result[place] = same_place_users + [u]
              user_count_on_same_place = user_count_on_same_place + 1
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
end