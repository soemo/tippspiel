# -*- encoding : utf-8 -*-

# liefert die Spiel-Ergebnisse und Teams in den weiteren Runden
# und aktualisiert die Spiele in der DB
# Es wird *footiefox* genutzt
# http://api.footiefox.com/teams.dat
# http://api.footiefox.com/leagues.dat
#
# EM2012 http://api.footiefox.com/leagues/107/base.json
# WM2014 http://api.footiefox.com/leagues/101/base.json

module FootieFox
  class UpdateGames < BaseService

    API_GAME_STATUS_FINISHED = 'finished'

    # footiefox team id => Tippspiel DB Teamname
    TEAMS = {
        920 => 'Brasilien',
        924 => 'Italien',
        925 => 'Chile',
        926 => 'Kamerun',
        928 => 'Frankreich',
        931 => 'Dänemark',
        932 => 'Spanien',
        933 => 'Nigeria',
        936 => 'Niederlande',
        937 => 'Belgien',
        938 => 'Südkorea',
        939 => 'Mexiko',
        940 => 'Deutschland',
        941 => 'USA',
        943 => 'Iran',
        945 => 'Kolumbien',
        946 => 'England',
        948 => 'Argentinien',
        949 => 'Japan',
        951 => 'Kroatien',
        1303 => 'Schweiz',
        1306 => 'Griechenland',
        1315 => 'Ukraine',
        1317 => 'Polen',
        1318 => 'Schweden',
        1323 => 'Portugal',
        1327 => 'Irland',
        1332 => 'Bosnien-Herzegowina',
        1333 => 'Tschechien',
        1335 => 'Russland',
        1612 => 'Ghana',
        1621 => 'Algerien',
        3128 => 'Ecuador',
        3130 => 'Uruguay',
        3133 => 'Australien',
        3500 => 'Costa Rica',
        3560 => 'Honduras',
        3599 => 'Elfenbeinküste',
    }

    def call
      update_games
    end

    private

    def update_games
      infos       = []
      result      = FootieFox::GetResults.call(result_url: RESULT_URL)
      json_result = result.json_result
      errors      = result.errors

      if json_result.present?
        check_and_update_new_data(json_result, errors, infos)
      end

      Rails.logger.error(errors.inspect) if errors.present?
      Rails.logger.info(infos.inspect) if infos.present?

      if errors.present? || infos.present?
        AdminMailer.result_grabber_email(errors, infos).deliver_now
      end
    end

    def check_and_update_new_data(json_data, errors=[], infos=[])
      # pp json_data
      if json_data.present?
        game_results = json_data['matches']
        if game_results.present?
          known_team_keys = TEAMS.keys

          game_results.each do |game_result|
            api_match_id = game_result['matchID']
            api_team1_id = game_result['team1Id']
            api_team2_id = game_result['team2Id']
            api_team1_goals = game_result['team1Score']
            api_team2_goals = game_result['team2Score']
            api_status = game_result['status']

            game = Game.where(:api_match_id => api_match_id).first
            if game.present?
              # nur update, wenn es in der DB noch als nicht finished markiert ist
              unless game.finished?

                # Teamname 1
                update_team(api_team1_id, game, :team1_id, known_team_keys, errors, infos)
                # Teamname 2
                update_team(api_team2_id, game, :team2_id, known_team_keys, errors, infos)

                # Tore nur speichern, wenn das Spiel schon vorbei ist
                if api_status.present? && api_status == API_GAME_STATUS_FINISHED
                  game.update_columns({team1_goals: api_team1_goals.to_i,
                                       team2_goals: api_team2_goals.to_i,
                                       finished: true})
                  infos << "UPDATE_GAME: Game(#{game.to_s}) got new score #{game.team1_goals}:#{game.team2_goals} and set to finished"
                end
              end
            else
              errors << "check_and_update_new_data - no game with api_match_id: #{api_match_id}"
            end
          end
        end # no else
      end # no else
    end

    def update_team(api_team_id, game, game_attr_sym, known_team_keys, errors, infos)
      if api_team_id.present? && known_team_keys.include?(api_team_id)
        team = Team.find_by_name(TEAMS[api_team_id])
        if team.present?
          if team.id != game.send(game_attr_sym)
            game.update_attribute(game_attr_sym, team.id)
            infos << "UPDATE_GAME_TEAM: #{TEAMS[api_team_id]} (teamid #{team.id}) is new team for game id #{game.id}"
          end
        else
          errors << "check_and_update_new_data - team with name: #{TEAMS[api_team_id]} not exists!"
        end
      else
        unless api_team_id == -1
          errors << "check_and_update_new_data - api #{game_attr_sym}: #{api_team_id} not in known_team_keys"
        end
      end
    end

  end
end