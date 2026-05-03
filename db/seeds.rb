require_relative 'seeds/wm2026'

def clear_games_and_teams
  ActiveRecord::Base.connection.execute('TRUNCATE games')
  Team.with_deleted.delete_all
end

def country_code_map
  Seeds::Wm2026.country_code_map
end

def game_data
  Seeds::Wm2026.game_data
end

def create_team_and_game_data
  country_codes = country_code_map

  game_data.each do |data|
    team1_name = data[:team1_name].present? ? data.delete(:team1_name) : nil
    team2_name = data[:team2_name].present? ? data.delete(:team2_name) : nil
    team_ids = {}
    if team1_name.present?
      team1 = Team.where(name: team1_name).first_or_create
      team1.update_column(:country_code, country_codes[team1_name])
      team_ids = team_ids.merge({team1_id: team1.id})
    end
    if team2_name.present?
      team2 = Team.where(name: team2_name).first_or_create
      team2.update_column(:country_code, country_codes[team2_name])
      team_ids = team_ids.merge({team2_id: team2.id})
    end

    Game.create!(data.merge(team_ids))
  end
end

puts 'recreate team and game data'
clear_games_and_teams
create_team_and_game_data
puts 'ready!'
