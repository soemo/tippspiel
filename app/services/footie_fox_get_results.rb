# -*- encoding : utf-8 -*-

# ist für die lesende Kommunikation mit Footiefox vorgesehen
=begin
-- footiefox ---

# "requestLeagueBase: "+this.apiURL + "leagues/"+id+"/base.json "
-->   http://api.footiefox.com/leagues/1/base.json
* z.B. 1. ist Bundesliga 2010
# footiefox_d_message("requestLeagueUpdate: "+ this.apiURL + "leagues/"+id+"/update.json");
# http://api.footiefox.com/teams.dat
# http://api.footiefox.com/leagues.dat
### EM2012 http://api.footiefox.com/leagues/107/base.json !!!!
### WM http://api.footiefox.com/leagues/101/base.json !!!!

{"leagueID"=>107,
 "is_tournament"=>true,
 "timestamp"=>"2008-06-29 22:37:10",
 "matches"=>
     [{"tournament_group"=>"Gruppe A",
       "matchID"=>747128,
       "team1Id"=>1303,
       "team2Score"=>1,
       "team2Id"=>1333,
       "startTime"=>"2008-06-07 16:00:00",
       "team1Score"=>0,
       "phase"=>2,
       "status"=>"finished"
      }] ...
}
=end

class FootieFoxGetResults < BaseService

  attribute :result_url, String

  Result = Struct.new(:json_result, :errors)

  def call
    get_results
  end

  private

  def get_results
    json_result, errors = get(result_url)

    Result.new(json_result, errors)
  end

  def request_timeout
    300
  end

  def try_count
    3
  end

  def get(url)
    result      = nil
    error_array = []

    Rails.logger.info "Fetching #{url}"
    response, found, content_type = get_url(url)
    if found && (content_type =~ /application\/json/ || content_type =~ /text\/plain/)
      require 'json'
      result = JSON.parse(response.body) # Spiel-Liste wird geliefert

    else
      error_array << "Can't get result from #{url} (Response '#{response.inspect}')"
    end

    [result, error_array]
  end

  def get_url(url, counter = 1)

    begin
      uri               = URI.parse(url)
      http              = Net::HTTP.new(uri.host, uri.port)
      http.read_timeout = request_timeout #default 60
      response          = http.start { http.request(Net::HTTP::Get.new("#{uri.path}")) }
      found             = response.kind_of?(Net::HTTPSuccess)
      content_type      = response['content-type']
    rescue Exception => e # Hier koennen zuviel verschiedene Exceptions fliegen, um sie alle aufzuzaehlen
      content_type = nil
      found        = false
      response     = e
    end

    if (found == false) && (counter < try_count)
      sleep 1
      response, found, content_type = get_url(url, counter + 1)
    end

    [response, found, content_type]
  end

end