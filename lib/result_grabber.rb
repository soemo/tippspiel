# liefert die Spiel-Ergebnisse und Teams in den weiteren Runden
# und aktualisiert die Spiele in der DB
# Es wird *footiefox* genutzt
# http://api.footiefox.com/teams.dat
# http://api.footiefox.com/leagues.dat
#
# EM2012 http://api.footiefox.com/leagues/107/base.json


module ResultGrabber

   RESULT_URL_EM2012 = "http://api.footiefox.com/leagues/107/base.json"

   API_GAME_STATUS_FINISHED = "finished"

   # footiefox team id => Tippsiel DB Teamname
   EM20102_TEAMS = {
           924 => "Italien",
           928 => "Frankreich",
           931 => "Dänemark",
           932 => "Spanien",
           936 => "Niederlande",
           940 => "Deutschland",
           946 => "England",
           951 => "Kroatien",
           1306 => "Griechenland",
           1315 => "Ukraine",
           1317 => "Polen",
           1318 => "Schweden",
           1323 => "Portugal",
           1327 => "Irland",
           1333 => "Tschechien",
           1335 => "Russland"
   }

   def update_games
     errors     = []
     infos      = []
     grabber = FootieFox.new(RESULT_URL_EM2012)
     json_result = grabber.get_result(errors)
     if json_result.present?
       check_and_update_new_data(json_result, errors, infos)
     end

     Rails.logger.error(errors.inspect) if errors.present?
     Rails.logger.info(infos.inspect) if infos.present?

     if errors.present? || infos.present?
       AdminMailer.result_grabber_email(errors, infos).deliver
     end
   end

   def check_and_update_new_data(json_data, errors=[], infos=[])
     # pp json_data
     if json_data.present?
       game_results = json_data["matches"]
       if game_results.present?
         known_team_keys = EM20102_TEAMS.keys

         game_results.each do |game_result|
           api_match_id = game_result["matchID"]
           api_team1_id = game_result["team1Id"]
           api_team2_id = game_result["team2Id"]
           api_team1_goals = game_result["team1Score"]
           api_team2_goals = game_result["team2Score"]
           api_status = game_result["status"]

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
                 game.update_attributes({:team1_goals => api_team1_goals.to_i,
                                         :team2_goals => api_team2_goals.to_i,
                                         :finished => true})
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

   private

   def update_team(api_team_id, game, game_attr_sym, known_team_keys, errors, infos)
     #infos << "TEST in update_team: api_team_id: #{api_team_id}, game:#{game.inspect}, game_attr_sym:#{game_attr_sym}" # FIXME soeren 18.06.12 raus
     if api_team_id.present? && known_team_keys.include?(api_team_id)
       #infos << "TEST in update_team if" # FIXME soeren 18.06.12 raus
       team = Team.find_by_name(EM20102_TEAMS[api_team_id])
       #infos << "TEST team: #{team.inspect}" # FIXME soeren 18.06.12 raus
       if team.present?
         #infos << "TEST team exists" # FIXME soeren 18.06.12 raus
         if team.id != game.send(game_attr_sym)
           game.update_attribute(game_attr_sym, team.id)
           infos << "UPDATE_GAME_TEAM: #{EM20102_TEAMS[api_team_id]} (teamid #{team.id}) is new team for game id #{game.id}"
         end
       else
         errors << "check_and_update_new_data - team with name: #{EM20102_TEAMS[api_team_id]} not exists!"
       end
     else
       unless api_team_id == -1
         errors << "check_and_update_new_data - api #{game_attr_sym}: #{api_team_id} not in known_team_keys"
       end
     end
   end


   # Diese Klasse ist für die lesende Kommunikation mit Footiefox vorgesehen
  class FootieFox

    REQUEST_TIMEOUT = 300
    TRY_COUNT       = 3

    def initialize(url)
      @url = url
    end

    def get_result(error_array)
      get(@url, error_array)
    end



    private

    def get(url, error_array)
      result = nil

      Rails.logger.info "Fetching #{url}"
      response, found, content_type = get_url(url)
      if found && (content_type =~ /application\/json/ || content_type =~ /text\/plain/)
        require 'json'
        result = JSON.parse(response.body) # Spiel-Liste wird geliefert

      else
        error_array << "Can't get result from #{url} (Response '#{response.inspect}')"
      end

      result
    end

    def get_url(url, counter = 1)

      begin
        uri               = URI.parse(url)
        http              = Net::HTTP.new(uri.host, uri.port)
        http.read_timeout = REQUEST_TIMEOUT #default 60
        response          = http.start { http.request(Net::HTTP::Get.new("#{uri.path}")) }
        found             = response.kind_of?(Net::HTTPSuccess)
        content_type      = response['content-type']
      rescue Exception => e # Hier koennen zuviel verschiedene Exceptions fliegen, um sie alle aufzuzaehlen
        content_type = nil
        found        = false
        response     = e
      end

      if (found == false) && (counter < TRY_COUNT)
        sleep 1
        response, found, content_type = get_url(url, counter + 1)
      end

      [response, found, content_type]
    end
  end

end