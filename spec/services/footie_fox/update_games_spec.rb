# -*- encoding : utf-8 -*-
require 'rails_helper'

describe FootieFox::UpdateGames do

  subject { FootieFox::UpdateGames }

  describe "calculate all user tipp points" do
    before :each do
      Game.destroy_all

      @italy_api_team_id   = 924
      create(:team, :name => subject::TEAMS[@italy_api_team_id])
      @germany_api_team_id = 940
      create(:team, :name => subject::TEAMS[@germany_api_team_id])
      @england_api_team_id = 946
      create(:team, :name => subject::TEAMS[@england_api_team_id])
      @polen_api_team_id   = 1317
      create(:team, :name => subject::TEAMS[@polen_api_team_id])

      @api_game1_team1_score = 1
      @api_game1_team2_score = 2

      @api_game2_team1_score = 3
      @api_game2_team2_score = 4

      @api_game3_team1_score = 5
      @api_game3_team2_score = 6

      @game1_api_match_id = 1
      @game2_api_match_id = 2
      @game3_api_match_id = 3

      @game1 = create(:game,
                      :team1_goals => nil,
                      :team2_goals => nil,
                      :api_match_id => @game1_api_match_id)
      @game2 = create(:game,
                      :team1_goals => nil,
                      :team2_goals => nil,
                      :api_match_id => @game2_api_match_id)
      # Hat noch gar keine Teams, nur team_placeholder_name
      @game3 = create(:game,
                      :team1_goals => nil,
                      :team2_goals => nil,
                      :team1_id => nil,
                      :team2_id => nil,
                      :team1_placeholder_name => "teamname placeholder 1",
                      :team2_placeholder_name => "teamname placeholder 2",
                      :api_match_id => @game3_api_match_id)

      [@game1, @game2, @game3].each do |game|
        if game.team1.present?
          expect(game.team1.name).to match(/teamname/)
        else
          expect(game.team1_placeholder_name).to match(/teamname/)
        end
        if game.team2.present?
          expect(game.team2.name).to match(/teamname/)
        else
          expect(game.team2_placeholder_name).to match(/teamname/)
        end
      end
    end

    it "get error" do
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
      subject.new.send('check_and_update_new_data', json_data, errors, infos)
      expect(errors[0]).to eq("check_and_update_new_data - no game with api_match_id: 42")
      expect(infos).to be_empty

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
      subject.new.send('check_and_update_new_data', json_data, errors, infos)
      expect(errors[0]).to eq("check_and_update_new_data - api team1_id: 2 not in known_team_keys")
      expect(infos).to be_empty

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
      subject.new.send('check_and_update_new_data', json_data, errors, infos)
      expect(errors[0]).to eq("check_and_update_new_data - api team2_id: 2 not in known_team_keys")
      expect(infos).to be_empty
    end

    it "not update teams with teamId -1" do
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

      subject.new.send('check_and_update_new_data', json_data, errors, infos)
      expect(errors).to be_empty
      expect(infos).to be_empty

      game3 = Game.find(@game3.id)
      expect(game3.team1).to eq(nil)
      expect(game3.team1_placeholder_name).to match(/teamname/)
      expect(game3.team2).to eq(nil)
      expect(game3.team2_placeholder_name).to match(/teamname/)
      expect(game3.team1_goals).to eq(nil)
      expect(game3.team2_goals).to eq(nil)
      expect(game3.finished).to eq(false)

    end


    it "update team names but not game goals" do
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

      subject.new.send('check_and_update_new_data', json_data, errors, infos)
      expect(errors).to be_empty
      expect(infos).to be_present

      game1 = Game.find(@game1.id)
      expect(game1.team1.name).to eq(subject::TEAMS[@germany_api_team_id])
      expect(game1.team2.name).to eq(subject::TEAMS[@italy_api_team_id])
      expect(game1.team1_goals).to eq(nil)
      expect(game1.team2_goals).to eq(nil)
      expect(game1.finished).to eq(false)

      game2 = Game.find(@game2.id)
      expect(game2.team1.name).to eq(subject::TEAMS[@england_api_team_id])
      expect(game2.team2.name).to eq(subject::TEAMS[@germany_api_team_id])
      expect(game2.team1_goals).to eq(nil)
      expect(game2.team2_goals).to eq(nil)
      expect(game2.finished).to eq(false)

      game3 = Game.find(@game3.id)
      expect(game3.team1.name).to eq(subject::TEAMS[@germany_api_team_id])
      expect(game3.team2.name).to eq(subject::TEAMS[@polen_api_team_id])
      expect(game3.team1_goals).to eq(nil)
      expect(game3.team2_goals).to eq(nil)
      expect(game3.finished).to eq(false)

    end

    it "update team names and game1 goals" do
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

      subject.new.send('check_and_update_new_data', json_data)

      game1 = Game.find(@game1.id)
      expect(game1.team1.name).to eq(subject::TEAMS[@germany_api_team_id])
      expect(game1.team2.name).to eq(subject::TEAMS[@italy_api_team_id])
      expect(game1.team1_goals).to eq(@api_game1_team1_score)
      expect(game1.team2_goals).to eq(@api_game1_team2_score)
      expect(game1.finished).to eq(true)

      game2 = Game.find(@game2.id)
      expect(game2.team1.name).to eq(subject::TEAMS[@england_api_team_id])
      expect(game2.team2.name).to eq(subject::TEAMS[@germany_api_team_id])
      expect(game2.team1_goals).to eq(nil)
      expect(game2.team2_goals).to eq(nil)
      expect(game2.finished).to eq(false)

      game3 = Game.find(@game3.id)
      expect(game3.team1.name).to eq(subject::TEAMS[@germany_api_team_id])
      expect(game3.team2.name).to eq(subject::TEAMS[@polen_api_team_id])
      expect(game3.team1_goals).to eq(nil)
      expect(game3.team2_goals).to eq(nil)
      expect(game3.finished).to eq(false)

    end

    it "not update team names and goals (because game is in DB marked as finished)" do
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

      subject.new.send('check_and_update_new_data', json_data)

      game1 = Game.find(@game1.id)
      expect(game1.team1.name).not_to eq(subject::TEAMS[@germany_api_team_id])
      expect(game1.team2.name).not_to eq(subject::TEAMS[@italy_api_team_id])
      expect(game1.team1_goals).to eq(nil)
      expect(game1.team2_goals).to eq(nil)
      expect(game1.finished).to eq(true)
    end

    it "update team names and all game" do
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

      subject.new.send('check_and_update_new_data', json_data)

      game1 = Game.find(@game1.id)
      expect(game1.team1.name).to eq(subject::TEAMS[@germany_api_team_id])
      expect(game1.team2.name).to eq(subject::TEAMS[@italy_api_team_id])
      expect(game1.team1_goals).to eq(@api_game1_team1_score)
      expect(game1.team2_goals).to eq(@api_game1_team2_score)
      expect(game1.finished).to eq(true)

      game2 = Game.find(@game2.id)
      expect(game2.team1.name).to eq(subject::TEAMS[@england_api_team_id])
      expect(game2.team2.name).to eq(subject::TEAMS[@germany_api_team_id])
      expect(game2.team1_goals).to eq(@api_game2_team1_score)
      expect(game2.team2_goals).to eq(@api_game2_team2_score)
      expect(game2.finished).to eq(true)

      game3 = Game.find(@game3.id)
      expect(game3.team1.name).to eq(subject::TEAMS[@germany_api_team_id])
      expect(game3.team2.name).to eq(subject::TEAMS[@polen_api_team_id])
      expect(game3.team1_goals).to eq(@api_game3_team1_score)
      expect(game3.team2_goals).to eq(@api_game3_team2_score)
      expect(game3.finished).to eq(true)

    end

  end

end