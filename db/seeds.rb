def clear_games
  ActiveRecord::Base.connection.execute('TRUNCATE games')
end

# flags from https://github.com/lafeber/world-flags-sprite
# The countries corresponding to the codes can be found at http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
# http://de.wikipedia.org/wiki/ISO-3166-1-Kodierliste
def country_code_map
  {
      'Ägypten' => 'eg',
      'Albanien' => 'al',
      'Algerien' => 'dz',
      'Argentinien' => 'ar',
      'Australien' => 'au',
      'Belgien' => 'be',
      'Bosnien-Herzegowina' => 'ba',
      'Brasilien' => 'br',
      'Chile' => 'cl',
      'Costa Rica' => 'cr',
      'Dänemark' => 'dk',
      'Deutschland' => 'de',
      'Ecuador' => 'ec',
      'Elfenbeinküste' => 'ci',
      'England' => '_England',
      'Frankreich' => 'fr',
      'Ghana' => 'gh',
      'Griechenland' => 'gr',
      'Honduras' => 'hn',
      'Iran' => 'ir',
      'Irland' => 'ie',
      'Island' => 'is',
      'Italien' => 'it',
      'Japan' => 'jp',
      'Kamerun' => 'cm',
      'Kolumbien' => 'co',
      'Kroatien' => 'hr',
      'Marokko' => 'ma',
      'Mexiko' => 'mx',
      'Niederlande' => 'nl',
      'Nigeria' => 'ng',
      'Nordirland' => '_Northern_Ireland',
      'Österreich' => 'at',
      'Panama' => 'pa',
      'Peru' => 'pe',
      'Polen' => 'pl',
      'Portugal' => 'pt',
      'Rumänien' => 'ro',
      'Russland' => 'ru',
      'Saudi-Arabien' => 'sa',
      'Schweden' => 'se',
      'Schweiz' => 'ch',
      'Senegal' => 'sn',
      'Serbien' => 'rs',
      'Slowakei' => 'sk',
      'Spanien' => 'es',
      'Südkorea' => 'kr',
      'Tschechien' => 'cz',
      'Tunesien' => 'tn',
      'Türkei' => 'tr',
      'Ukraine' => 'ua',
      'Ungarn' => 'hu',
      'USA' => 'us',
      'Uruguay' => 'uy',
      'Wales' => '_Wales'
  }
end


# data from http://www.em2016-infos.de/em-2016-spielplan/
def game_data
  [
      # Gruppe A
      {start_at: '14.06.2018 17:00', place: 'Moskau', team1_name: 'Russland', team2_name: 'Saudi-Arabien', group: GROUP_A, round: GROUP},
      {start_at: '15.06.2018 14:00', place: 'Jekaterinburg', team1_name: 'Ägypten', team2_name: 'Uruguay', group: GROUP_A, round: GROUP},
      {start_at: '19.06.2018 20:00', place: 'Sankt Petersburg', team1_name: 'Russland ', team2_name: 'Ägypten', group: GROUP_A, round: GROUP},
      {start_at: '20.06.2018 17:00', place: 'Rostow am Don', team1_name: 'Uruguay', team2_name: 'Saudi-Arabien', group: GROUP_A, round: GROUP},
      {start_at: '25.06.2018 16:00', place: 'Samara', team1_name: 'Uruguay', team2_name: 'Russland', group: GROUP_A, round: GROUP},
      {start_at: '25.06.2018 16:00', place: 'Wolgograd', team1_name: 'Saudi-Arabien', team2_name: 'Ägypten', group: GROUP_A, round: GROUP},

      # Gruppe B
      {start_at: '15.06.2018 17:00', place: 'Sankt Petersburg', team1_name: 'Marokko', team2_name: 'Iran', group: GROUP_B, round: GROUP},
      {start_at: '15.06.2018 20:00', place: 'Sotschi', team1_name: 'Portugal', team2_name: 'Spanien', group: GROUP_B, round: GROUP},
      {start_at: '20.06.2018 14:00', place: 'Moskau', team1_name: 'Portugal', team2_name: 'Marokko', group: GROUP_B, round: GROUP},
      {start_at: '20.06.2018 20:00', place: 'Kasan', team1_name: 'Iran', team2_name: 'Spanien', group: GROUP_B, round: GROUP},
      {start_at: '25.06.2018 20:00', place: 'Kaliningrad', team1_name: 'Spanien', team2_name: 'Marokko', group: GROUP_B, round: GROUP},
      {start_at: '25.06.2018 20:00', place: 'Saransk', team1_name: 'Iran', team2_name: 'Portugal', group: GROUP_B, round: GROUP},

      # Gruppe C
      {start_at: '16.06.2018 12:00', place: 'Kasan', team1_name: 'Frankreich', team2_name: 'Australien', group: GROUP_C, round: GROUP},
      {start_at: '16.06.2018 18:00', place: 'Saransk', team1_name: 'Peru', team2_name: 'Dänemark', group: GROUP_C, round: GROUP},
      {start_at: '21.06.2018 17:00', place: 'Jekaterinburg', team1_name: 'Frankreich', team2_name: 'Peru', group: GROUP_C, round: GROUP},
      {start_at: '21.06.2018 14:00', place: 'Samara', team1_name: 'Dänemark', team2_name: 'Australien', group: GROUP_C, round: GROUP},
      {start_at: '26.06.2018 16:00', place: 'Moskau', team1_name: 'Dänemark', team2_name: 'Frankreich', group: GROUP_C, round: GROUP},
      {start_at: '26.06.2018 16:00', place: 'Sotschi', team1_name: 'Australien', team2_name: 'Peru', group: GROUP_C, round: GROUP},

      # Gruppe D
      {start_at: '16.06.2018 15:00', place: 'Moskau', team1_name: 'Argentinien', team2_name: 'Island', group: GROUP_D, round: GROUP},
      {start_at: '16.06.2018 21:00', place: 'Kaliningrad', team1_name: 'Kroatien', team2_name: 'Nigeria', group: GROUP_D, round: GROUP},
      {start_at: '21.06.2018 20:00', place: 'Nischni Nowgorod', team1_name: 'Argentinien', team2_name: 'Kroatien', group: GROUP_D, round: GROUP},
      {start_at: '22.06.2018 17:00', place: 'Wolgograd', team1_name: 'Nigeria', team2_name: 'Island', group: GROUP_D, round: GROUP},
      {start_at: '26.06.2018 20:00', place: 'Rostow am Don', team1_name: 'Island', team2_name: 'Kroatien', group: GROUP_D, round: GROUP},
      {start_at: '26.06.2018 20:00', place: 'Sankt Petersburg', team1_name: 'Nigeria', team2_name: 'Argentinien', group: GROUP_D, round: GROUP},

      # Gruppe E
      {start_at: '17.06.2018 14:00', place: 'Samara', team1_name: 'Costa Rica', team2_name: 'Serbien', group: GROUP_E, round: GROUP},
      {start_at: '17.06.2018 20:00', place: 'Rostow am Don', team1_name: 'Brasilien', team2_name: 'Schweiz', group: GROUP_E, round: GROUP},
      {start_at: '22.06.2018 14:00', place: 'Sankt Petersburg', team1_name: 'Brasilien', team2_name: 'Costa Rica', group: GROUP_E, round: GROUP},
      {start_at: '22.06.2018 20:00', place: 'Kaliningrad', team1_name: 'Serbien', team2_name: 'Schweiz', group: GROUP_E, round: GROUP},
      {start_at: '27.06.2018 20:00', place: 'Moskau', team1_name: 'Serbien', team2_name: 'Brasilien', group: GROUP_E, round: GROUP},
      {start_at: '27.06.2018 20:00', place: 'Nischni Nowgorod', team1_name: 'Schweiz', team2_name: 'Costa Rica', group: GROUP_E, round: GROUP},

      # Gruppe F
      {start_at: '17.06.2018 17:00', place: 'Moskau', team1_name: 'Deutschland', team2_name: 'Mexiko', group: GROUP_F, round: GROUP},
      {start_at: '18.06.2018 14:00', place: 'Nischni Nowgorod', team1_name: 'Schweden', team2_name: 'Südkorea', group: GROUP_F, round: GROUP},
      {start_at: '23.06.2018 20:00', place: 'Sotschi', team1_name: 'Deutschland', team2_name: 'Schweden', group: GROUP_F, round: GROUP},
      {start_at: '23.06.2018 17:00', place: 'Rostow am Don', team1_name: 'Südkorea', team2_name: 'Mexiko', group: GROUP_F, round: GROUP},
      {start_at: '27.06.2018 16:00', place: 'Jekaterinburg', team1_name: 'Mexiko', team2_name: 'Schweden', group: GROUP_F, round: GROUP},
      {start_at: '27.06.2018 16:00', place: 'Kasan', team1_name: 'Südkorea', team2_name: 'Deutschland', group: GROUP_F, round: GROUP},

      # Gruppe G
      {start_at: '18.06.2018 17:00', place: 'Sotschi', team1_name: 'Belgien', team2_name: 'Panama', group: GROUP_F, round: GROUP},
      {start_at: '18.06.2018 20:00', place: 'Wolgograd', team1_name: 'Tunesien', team2_name: 'England', group: GROUP_F, round: GROUP},
      {start_at: '23.06.2018 14:00', place: 'Moskau', team1_name: 'Belgien', team2_name: 'Tunesien', group: GROUP_F, round: GROUP},
      {start_at: '24.06.2018 14:00', place: 'Nischni Nowgorod', team1_name: 'England', team2_name: 'Panama', group: GROUP_F, round: GROUP},
      {start_at: '28.06.2018 20:00', place: 'Kaliningrad', team1_name: 'England', team2_name: 'Belgien', group: GROUP_F, round: GROUP},
      {start_at: '28.06.2018 20:00', place: 'Saransk', team1_name: 'Panama', team2_name: 'Tunesien', group: GROUP_F, round: GROUP},

      # Gruppe H
      {start_at: '19.06.2018 17:00', place: 'Moskau', team1_name: 'Polen', team2_name: 'Senegal', group: GROUP_F, round: GROUP},
      {start_at: '19.06.2018 14:00', place: 'Saransk', team1_name: 'Kolumbien', team2_name: 'Japan', group: GROUP_F, round: GROUP},
      {start_at: '24.06.2018 17:00', place: 'Jekaterinburg', team1_name: 'Japan', team2_name: 'Senegal', group: GROUP_F, round: GROUP},
      {start_at: '24.06.2018 20:00', place: 'Kasan', team1_name: 'Polen', team2_name: 'Kolumbien', group: GROUP_F, round: GROUP},
      {start_at: '28.06.2018 16:00', place: 'Samara', team1_name: 'Senegal', team2_name: 'Kolumbien', group: GROUP_F, round: GROUP},
      {start_at: '28.06.2018 16:00', place: 'Wolgograd', team1_name: 'Japan', team2_name: 'Polen', group: GROUP_F, round: GROUP},

      # Achtelfinale
      {start_at: '30.06.2018 16:00', place: 'Kasan', team1_placeholder_name: '1. Gruppe C', team2_placeholder_name: '2. Gruppe D', group: nil, round: ROUND_OF_16},
      {start_at: '30.06.2018 20:00', place: 'Sotschi', team1_placeholder_name: '1. Gruppe A', team2_placeholder_name: '2. Gruppe B', group: nil, round: ROUND_OF_16},
      {start_at: '01.07.2018 16:00', place: 'Moskau', team1_placeholder_name: '1. Gruppe B', team2_placeholder_name: '2. Gruppe A', group: nil, round: ROUND_OF_16},
      {start_at: '01.07.2018 20:00', place: 'Nischni Nowgorod', team1_placeholder_name: '1. Gruppe D', team2_placeholder_name: '2. Gruppe C', group: nil, round: ROUND_OF_16},
      {start_at: '02.07.2018 16:00', place: 'Samara', team1_placeholder_name: '1. Gruppe E', team2_placeholder_name: '2. Gruppe F', group: nil, round: ROUND_OF_16},
      {start_at: '02.07.2018 20:00', place: 'Rostow am Don', team1_placeholder_name: '1. Gruppe G', team2_placeholder_name: '2. Gruppe H', group: nil, round: ROUND_OF_16},
      {start_at: '03.07.2018 16:00', place: 'Sankt Petersburg', team1_placeholder_name: '1. Gruppe F', team2_placeholder_name: '2. Gruppe E', group: nil, round: ROUND_OF_16},
      {start_at: '03.07.2018 20:00', place: 'Moskau', team1_placeholder_name: '1. Gruppe H', team2_placeholder_name: '2. Gruppe G', group: nil, round: ROUND_OF_16},

      # Viertelfinale
      {start_at: '06.07.2018 16:00', place: 'Nischni Nowgorod', team1_placeholder_name: '1. Achtelfinale 1', team2_placeholder_name: '1. Achtelfinale 2', group: nil, round: QUARTERFINAL},
      {start_at: '06.07.2018 20:00', place: 'Kasan', team1_placeholder_name: '1. Achtelfinale 6', team2_placeholder_name: '1. Achtelfinale 5', group: nil, round: QUARTERFINAL},
      {start_at: '07.07.2018 16:00', place: 'Samara', team1_placeholder_name: '1. Achtelfinale 8', team2_placeholder_name: '1. Achtelfinale 7', group: nil, round: QUARTERFINAL},
      {start_at: '07.07.2018 20:00', place: 'Sotschi', team1_placeholder_name: '1. Achtelfinale 3', team2_placeholder_name: '1. Achtelfinale 4', group: nil, round: QUARTERFINAL},

      # Halbfinale
      {start_at: '10.07.2018 20:00', place: 'Sankt Petersburg', team1_placeholder_name: '1. Viertelfinale 2', team2_placeholder_name: '1. Viertelfinale 1', group: nil, round: SEMIFINAL},
      {start_at: '11.07.2018 21:00', place: 'Moskau', team1_placeholder_name: '1. Viertelfinale 4', team2_placeholder_name: '1. Viertelfinale 3', group: nil, round: SEMIFINAL},

      # Spiel um Platz 3
      {start_at: '14.07.2018 16:00', place: 'Sankt Petersburg', team1_placeholder_name: '2. Halbfinale 1', team2_placeholder_name: '2. Halbfinale 2', group: nil, round: PLACE_3},

      # Finale
      {start_at: '15.07.2018 17:00', place: 'Moskau', team1_placeholder_name: '1. Halbfinale 1', team2_placeholder_name: '1. Halbfinale 2', group: nil, round: FINAL},
  ]
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
clear_games
create_team_and_game_data
puts 'ready!'

