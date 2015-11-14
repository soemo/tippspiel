# -*- encoding : utf-8 -*-
module Users
  class PrepareRanking < BaseService

    attribute :users_for_ranking, Array[User]

    def call
      prepare_user_ranking
    end

    private

    # bekommt eine Liste von Usern
    # sortiert nach Gesamtpunkten, Anzahl6Punkte, Anzahl4Punkte und Anzahl3Punkte geliefert
    # Es wird noch die Platzierung als Key hinzugefuegt
    # (wenn 3 Leute erster sind, ist der nächste dann auf Platz 4)
    # ACHTUNG DER HASH IST NICHT SORTIERT !!!!
    def prepare_user_ranking
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
            if last_used_user.ranking_comparison_value > u.ranking_comparison_value
              place = place + user_count_on_same_place
              result[place] = [u]
              user_count_on_same_place = 1
            elsif last_used_user.ranking_comparison_value == u.ranking_comparison_value
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