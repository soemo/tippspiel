# -*- encoding : utf-8 -*-
class AddApiMatchIdToGame < ActiveRecord::Migration

  class Game < ActiveRecord::Base;end

  def up
    add_column :games, :api_match_id, :integer, :null => false
    Game.reset_column_information

    data
  end

  def data
    [
            {:match_id =>1122625, :start_at => '2012-06-08 16:00:00', :team1_name => 'Polen', :team2_name => 'Griechenland'},
            {:match_id =>1122626, :start_at => '2012-06-12 18:45:00', :team1_name => 'Polen', :team2_name => 'Russland'},
            {:match_id =>1122627, :start_at => '2012-06-16 18:45:00', :team1_name => 'Tschechien', :team2_name => 'Polen'},
            {:match_id =>1122628, :start_at => '2012-06-11 18:45:00', :team1_name => 'Ukraine', :team2_name => 'Schweden'},
            {:match_id =>1122629, :start_at => '2012-06-19 18:45:00', :team1_name => 'England', :team2_name => 'Ukraine'},
            {:match_id =>1122630, :start_at => '2012-06-15 16:00:00', :team1_name => 'Ukraine', :team2_name => 'Frankreich'},
            {:match_id =>1122631, :start_at => '2012-06-08 18:45:00', :team1_name => 'Russland', :team2_name => 'Tschechien'},
            {:match_id =>1122632, :start_at => '2012-06-12 16:00:00', :team1_name => 'Griechenland', :team2_name => 'Tschechien'},
            {:match_id =>1122633, :start_at => '2012-06-16 18:45:00', :team1_name => 'Griechenland', :team2_name => 'Russland'},
            {:match_id =>1122666, :start_at => '2012-06-09 16:00:00', :team1_name => 'Niederlande', :team2_name => 'Dänemark'},
            {:match_id =>1122667, :start_at => '2012-06-09 18:45:00', :team1_name => 'Deutschland', :team2_name => 'Portugal'},
            {:match_id =>1122668, :start_at => '2012-06-13 18:45:00', :team1_name => 'Niederlande', :team2_name => 'Deutschland'},
            {:match_id =>1122669, :start_at => '2012-06-13 16:00:00', :team1_name => 'Dänemark', :team2_name => 'Portugal'},
            {:match_id =>1122670, :start_at => '2012-06-17 18:45:00', :team1_name => 'Portugal', :team2_name => 'Niederlande'},
            {:match_id =>1122671, :start_at => '2012-06-17 18:45:00', :team1_name => 'Dänemark', :team2_name => 'Deutschland'},
            {:match_id =>1122672, :start_at => '2012-06-10 16:00:00', :team1_name => 'Spanien', :team2_name => 'Italien'},
            {:match_id =>1122673, :start_at => '2012-06-10 18:45:00', :team1_name => 'Irland', :team2_name => 'Kroatien'},
            {:match_id =>1122674, :start_at => '2012-06-14 18:45:00', :team1_name => 'Spanien', :team2_name => 'Irland'},
            {:match_id =>1122675, :start_at => '2012-06-14 16:00:00', :team1_name => 'Italien', :team2_name => 'Kroatien'},
            {:match_id =>1122676, :start_at => '2012-06-18 18:45:00', :team1_name => 'Kroatien', :team2_name => 'Spanien'},
            {:match_id =>1122677, :start_at => '2012-06-18 18:45:00', :team1_name => 'Italien', :team2_name => 'Irland'},
            {:match_id =>1122678, :start_at => '2012-06-11 16:00:00', :team1_name => 'Frankreich', :team2_name => 'England'},
            {:match_id =>1122679, :start_at => '2012-06-15 18:45:00', :team1_name => 'Schweden', :team2_name => 'England'},
            {:match_id =>1122680, :start_at => '2012-06-19 18:45:00', :team1_name => 'Schweden', :team2_name => 'Frankreich'},
            {:match_id =>1122681, :start_at => '2012-06-21 18:45:00'},
            {:match_id =>1122682, :start_at => '2012-06-22 18:45:00'},
            {:match_id =>1122683, :start_at => '2012-06-23 18:45:00'},
            {:match_id =>1122684, :start_at => '2012-06-24 18:45:00'},
            {:match_id =>1122685, :start_at => '2012-06-28 18:45:00'},
            {:match_id =>1122686, :start_at => '2012-06-27 18:45:00'},
            {:match_id =>1122687, :start_at => '2012-07-01 18:45:00'}
    ].each do |match|
      pp ("work for  #{match[:match_id]}")
      team1 = Team.where(:name => match[:team1_name]).first
      team2 = Team.where(:name => match[:team2_name]).first
      if team1.present? && team2.present?
        game = Game.where(:start_at => match[:start_at]).where(:team1_id => team1.id).where(:team2_id => team2.id).first
      else
        game = Game.where(:start_at => match[:start_at]).first
      end
      if game.present?
        game.update_attribute(:api_match_id, match[:match_id])
        pp("set #{match[:match_id]} for game id: #{game.id}")
      else
        raise("no game found with #{match[:cond]}")
      end
    end
  end

  def down
    remove_column :games, :api_match_id
  end
end
