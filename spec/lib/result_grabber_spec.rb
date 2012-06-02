require 'spec_helper'

describe ResultGrabber do

  include ResultGrabber

  describe "calculate all user tipp points" do
    before :each do
      Game.destroy_all

      @italy_api_team_id   = 924
      Factory(:team, :name => ResultGrabber::EM20102_TEAMS[@italy_api_team_id])
      @germany_api_team_id = 940
      Factory(:team, :name => ResultGrabber::EM20102_TEAMS[@germany_api_team_id])
      @england_api_team_id = 946
      Factory(:team, :name => ResultGrabber::EM20102_TEAMS[@england_api_team_id])
      @polen_api_team_id   = 1317
      Factory(:team, :name => ResultGrabber::EM20102_TEAMS[@polen_api_team_id])

      @api_game1_team1_score = 1
      @api_game1_team2_score = 2

      @api_game2_team1_score = 3
      @api_game2_team2_score = 4

      @api_game3_team1_score = 5
      @api_game3_team2_score = 6

      @game1_api_match_id = 1
      @game2_api_match_id = 2
      @game3_api_match_id = 3

      @game1 = Factory(:game, 
                       :team1_goals => nil, 
                       :team2_goals => nil, 
                       :api_match_id => @game1_api_match_id)
      @game2 = Factory(:game, 
                       :team1_goals => nil, 
                       :team2_goals => nil, 
                       :api_match_id => @game2_api_match_id)
      # Hat noch gar keine Teams, nur team_placeholder_name
      @game3 = Factory(:game, 
                       :team1_goals => nil, 
                       :team2_goals => nil,
                       :team1_id => nil,
                       :team2_id => nil,
                       :team1_placeholder_name => "teamname placeholder 1",
                       :team2_placeholder_name => "teamname placeholder 2",
                       :api_match_id => @game3_api_match_id)
      
      [@game1, @game2, @game3].each do |game|
        if game.team1.present?
          game.team1.name.should =~ /teamname/
        else
          game.team1_placeholder_name.should =~ /teamname/
        end
        if game.team2.present?
          game.team2.name.should =~ /teamname/
        else
          game.team2_placeholder_name.should =~ /teamname/
        end
      end
    end

    it "should get error" do
      errors = []
      infos  = []
      json_data = {"leagueID" => 107,
                   "is_tournament" => true,
                   "timestamp" => "2012-04-27 17:31:50",
                   "matches" =>
                           [
                                   {"tournament_group" => "FINAL",
                                    "matchID" => 42, #unknown match id
                                    "team1Id" => 2, # unknown id
                                    "team1Score" => @api_game3_team1_score,
                                    "team2Id" => -1,
                                    "team2Score" => @api_game3_team2_score,
                                    "startTime" => "2012-06-16 18:45:00",
                                    "status" => "scheduled",
                                    "phase" => 0}
                           ]}
      check_and_update_new_data(json_data, errors, infos)
      errors[0].should == "check_and_update_new_data - no game with api_match_id: 42"
      infos.should be_empty

      json_data = {"leagueID" => 107,
                   "is_tournament" => true,
                   "timestamp" => "2012-04-27 17:31:50",
                   "matches" =>
                           [
                                   {"tournament_group" => "FINAL",
                                    "matchID" => @game3_api_match_id,
                                    "team1Id" => 2, # unknown id
                                    "team1Score" => @api_game3_team1_score,
                                    "team2Id" => -1,
                                    "team2Score" => @api_game3_team2_score,
                                    "startTime" => "2012-06-16 18:45:00",
                                    "status" => "scheduled",
                                    "phase" => 0}
                           ]}
      errors = []
      infos  = []
      check_and_update_new_data(json_data, errors, infos)
      errors[0].should == "check_and_update_new_data - api team1_id: 2 not in known_team_keys"
      infos.should be_empty

      json_data = {"leagueID" => 107,
                   "is_tournament" => true,
                   "timestamp" => "2012-04-27 17:31:50",
                   "matches" =>
                           [
                                   {"tournament_group" => "FINAL",
                                    "matchID" => @game3_api_match_id,
                                    "team1Id" => -1,
                                    "team1Score" => @api_game3_team1_score,
                                    "team2Id" => 2,# unknown id
                                    "team2Score" => @api_game3_team2_score,
                                    "startTime" => "2012-06-16 18:45:00",
                                    "status" => "scheduled",
                                    "phase" => 0}
                           ]}
      errors = []
      infos  = []
      check_and_update_new_data(json_data, errors, infos)
      errors[0].should == "check_and_update_new_data - api team2_id: 2 not in known_team_keys"
      infos.should be_empty
    end

    it "should not update teams with teamId -1" do
      errors = []
      infos  = []
      json_data = {"leagueID" => 107,
                   "is_tournament" => true,
                   "timestamp" => "2012-04-27 17:31:50",
                   "matches" =>
                           [
                            {"tournament_group" => "FINAL",
                             "matchID" => @game3_api_match_id,
                             "team1Id" => -1,
                             "team1Score" => @api_game3_team1_score,
                             "team2Id" => -1,
                             "team2Score" => @api_game3_team2_score,
                             "startTime" => "2012-06-16 18:45:00",
                             "status" => "scheduled",
                             "phase" => 0}
                           ]}

      check_and_update_new_data(json_data, errors, infos)
      errors.should be_empty
      infos.should be_empty

      game3 = Game.find(@game3.id)
      game3.team1.should == nil
      game3.team1_placeholder_name.should =~ /teamname/
      game3.team2.should == nil
      game3.team2_placeholder_name.should =~ /teamname/
      game3.team1_goals.should == nil
      game3.team2_goals.should == nil
      game3.finished.should == false

    end


    it "should update team names but not game goals" do
      errors = []
      infos  = []

      # Spiele sind noch nicht beendet
      json_data = {"leagueID" => 107,
                   "is_tournament" => true,
                   "timestamp" => "2012-04-27 17:31:50",
                   "matches" =>
                           [{"tournament_group" => "Gruppe A",
                             "matchID" => @game1_api_match_id,
                             "team1Id" => @germany_api_team_id,
                             "team1Score" => @api_game1_team1_score,
                             "team2Id" => @italy_api_team_id,
                             "team2Score" => @api_game1_team2_score,
                             "startTime" => "2012-06-08 16:00:00",
                             "status" => "scheduled",
                             "phase" => 0},
                            {"tournament_group" => "Gruppe A",
                             "matchID" => @game2_api_match_id,
                             "team1Id" => @england_api_team_id,
                             "team1Score" => @api_game2_team1_score,
                             "team2Id" => @germany_api_team_id,
                             "team2Score" => @api_game2_team2_score,
                             "startTime" => "2012-06-12 18:45:00",
                             "status" => "scheduled",
                             "phase" => 0},
                            {"tournament_group" => "Gruppe A",
                             "matchID" => @game3_api_match_id,
                             "team1Id" => @germany_api_team_id,
                             "team1Score" => @api_game3_team1_score,
                             "team2Id" => @polen_api_team_id,
                             "team2Score" => @api_game3_team2_score,
                             "startTime" => "2012-06-16 18:45:00",
                             "status" => "scheduled",
                             "phase" => 0}
                           ]}

      check_and_update_new_data(json_data, errors, infos)
      errors.should be_empty
      infos.should be_present

      game1 = Game.find(@game1.id)
      game1.team1.name.should == ResultGrabber::EM20102_TEAMS[@germany_api_team_id]
      game1.team2.name.should == ResultGrabber::EM20102_TEAMS[@italy_api_team_id]
      game1.team1_goals.should == nil
      game1.team2_goals.should == nil
      game1.finished.should == false

      game2 = Game.find(@game2.id)
      game2.team1.name.should == ResultGrabber::EM20102_TEAMS[@england_api_team_id]
      game2.team2.name.should == ResultGrabber::EM20102_TEAMS[@germany_api_team_id]
      game2.team1_goals.should == nil
      game2.team2_goals.should == nil
      game2.finished.should == false

      game3 = Game.find(@game3.id)
      game3.team1.name.should == ResultGrabber::EM20102_TEAMS[@germany_api_team_id]
      game3.team2.name.should == ResultGrabber::EM20102_TEAMS[@polen_api_team_id]
      game3.team1_goals.should == nil
      game3.team2_goals.should == nil
      game3.finished.should == false

    end

    it "should update team names and game1 goals" do
      json_data = {"leagueID" => 107,
                   "is_tournament" => true,
                   "timestamp" => "2012-04-27 17:31:50",
                   "matches" =>
                           [{"tournament_group" => "Gruppe A",
                             "matchID" => @game1_api_match_id,
                             "team1Id" => @germany_api_team_id,
                             "team1Score" => @api_game1_team1_score,
                             "team2Id" => @italy_api_team_id,
                             "team2Score" => @api_game1_team2_score,
                             "startTime" => "2012-06-08 16:00:00",
                             "status" => "finished", # <--- beendet
                             "phase" => 0},
                            {"tournament_group" => "Gruppe A",
                             "matchID" => @game2_api_match_id,
                             "team1Id" => @england_api_team_id,
                             "team1Score" => @api_game2_team1_score,
                             "team2Id" => @germany_api_team_id,
                             "team2Score" => @api_game2_team2_score,
                             "startTime" => "2012-06-12 18:45:00",
                             "status" => "scheduled",
                             "phase" => 0},
                            {"tournament_group" => "Gruppe A",
                             "matchID" => @game3_api_match_id,
                             "team1Id" => @germany_api_team_id,
                             "team1Score" => @api_game3_team1_score,
                             "team2Id" => @polen_api_team_id,
                             "team2Score" => @api_game3_team2_score,
                             "startTime" => "2012-06-16 18:45:00",
                             "status" => "scheduled",
                             "phase" => 0}
                           ]}

      check_and_update_new_data(json_data)

      game1 = Game.find(@game1.id)
      game1.team1.name.should == ResultGrabber::EM20102_TEAMS[@germany_api_team_id]
      game1.team2.name.should == ResultGrabber::EM20102_TEAMS[@italy_api_team_id]
      game1.team1_goals.should == @api_game1_team1_score
      game1.team2_goals.should == @api_game1_team2_score
      game1.finished.should == true

      game2 = Game.find(@game2.id)
      game2.team1.name.should == ResultGrabber::EM20102_TEAMS[@england_api_team_id]
      game2.team2.name.should == ResultGrabber::EM20102_TEAMS[@germany_api_team_id]
      game2.team1_goals.should == nil
      game2.team2_goals.should == nil
      game2.finished.should == false

      game3 = Game.find(@game3.id)
      game3.team1.name.should == ResultGrabber::EM20102_TEAMS[@germany_api_team_id]
      game3.team2.name.should == ResultGrabber::EM20102_TEAMS[@polen_api_team_id]
      game3.team1_goals.should == nil
      game3.team2_goals.should == nil
      game3.finished.should == false

    end

    it "should not update team names and goals (because game is in DB marked as finished)" do
      # Spiele sind noch nicht beendet
      json_data = {"leagueID" => 107,
                   "is_tournament" => true,
                   "timestamp" => "2012-04-27 17:31:50",
                   "matches" =>
                           [{"tournament_group" => "Gruppe A",
                             "matchID" => @game1_api_match_id,
                             "team1Id" => @germany_api_team_id,
                             "team1Score" => @api_game1_team1_score,
                             "team2Id" => @italy_api_team_id,
                             "team2Score" => @api_game1_team2_score,
                             "startTime" => "2012-06-08 16:00:00",
                             "status" => "finished", # <--- beendet
                             "phase" => 0}
                           ]}

      game1 = Game.find(@game1.id)
      game1.update_attribute(:finished, true)

      check_and_update_new_data(json_data)

      game1 = Game.find(@game1.id)
      game1.team1.name.should_not == ResultGrabber::EM20102_TEAMS[@germany_api_team_id]
      game1.team2.name.should_not == ResultGrabber::EM20102_TEAMS[@italy_api_team_id]
      game1.team1_goals.should == nil
      game1.team2_goals.should == nil
      game1.finished.should == true
    end

    it "should update team names and all game" do
      json_data = {"leagueID" => 107,
                   "is_tournament" => true,
                   "timestamp" => "2012-04-27 17:31:50",
                   "matches" =>
                           [{"tournament_group" => "Gruppe A",
                             "matchID" => @game1_api_match_id,
                             "team1Id" => @germany_api_team_id,
                             "team1Score" => @api_game1_team1_score,
                             "team2Id" => @italy_api_team_id,
                             "team2Score" => @api_game1_team2_score,
                             "startTime" => "2012-06-08 16:00:00",
                             "status" => "finished", # <--- beendet
                             "phase" => 0},
                            {"tournament_group" => "Gruppe A",
                             "matchID" => @game2_api_match_id,
                             "team1Id" => @england_api_team_id,
                             "team1Score" => @api_game2_team1_score,
                             "team2Id" => @germany_api_team_id,
                             "team2Score" => @api_game2_team2_score,
                             "startTime" => "2012-06-12 18:45:00",
                             "status" => "finished", # <--- beendet
                             "phase" => 0},
                            {"tournament_group" => "Gruppe A",
                             "matchID" => @game3_api_match_id,
                             "team1Id" => @germany_api_team_id,
                             "team1Score" => @api_game3_team1_score,
                             "team2Id" => @polen_api_team_id,
                             "team2Score" => @api_game3_team2_score,
                             "startTime" => "2012-06-16 18:45:00",
                             "status" => "finished", # <--- beendet
                             "phase" => 0}
                           ]}

      check_and_update_new_data(json_data)

      game1 = Game.find(@game1.id)
      game1.team1.name.should == ResultGrabber::EM20102_TEAMS[@germany_api_team_id]
      game1.team2.name.should == ResultGrabber::EM20102_TEAMS[@italy_api_team_id]
      game1.team1_goals.should == @api_game1_team1_score
      game1.team2_goals.should == @api_game1_team2_score
      game1.finished.should == true

      game2 = Game.find(@game2.id)
      game2.team1.name.should == ResultGrabber::EM20102_TEAMS[@england_api_team_id]
      game2.team2.name.should == ResultGrabber::EM20102_TEAMS[@germany_api_team_id]
      game2.team1_goals.should == @api_game2_team1_score
      game2.team2_goals.should == @api_game2_team2_score
      game2.finished.should == true

      game3 = Game.find(@game3.id)
      game3.team1.name.should == ResultGrabber::EM20102_TEAMS[@germany_api_team_id]
      game3.team2.name.should == ResultGrabber::EM20102_TEAMS[@polen_api_team_id]
      game3.team1_goals.should == @api_game3_team1_score
      game3.team2_goals.should == @api_game3_team2_score
      game3.finished.should == true

    end

  end

end