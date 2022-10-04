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
      'Finnland' => 'fi',
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
      'Kanada' => 'ca',
      'Katar' => 'kz',
      'Kolumbien' => 'co',
      'Kroatien' => 'hr',
      'Marokko' => 'ma',
      'Mexiko' => 'mx',
      'Niederlande' => 'nl',
      'Nigeria' => 'ng',
      'Nordirland' => '_Northern_Ireland',
      'Nordmazedonien' => 'mk',
      'Österreich' => 'at',
      'Panama' => 'pa',
      'Peru' => 'pe',
      'Polen' => 'pl',
      'Portugal' => 'pt',
      'Rumänien' => 'ro',
      'Russland' => 'ru',
      'Saudi-Arabien' => 'sa',
      'Schottland' => '_Scotland',
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

# data from
# EM2020 https://de.uefa.com/uefaeuro-2020/news/0253-0d820ec63626-e75859a771ad-1000--spielplan-der-uefa-euro-2020/
# WM2022 https://www.fifa.com/fifaplus/de/match-centre/competition/17?date=2022-11-20&tab=competitionMatches&prev=competition
#        , https://de.wikipedia.org/wiki/Fu%C3%9Fball-Weltmeisterschaft_2022 and https://www.fussball-wm.pro/wm-2022/spielplan/
def game_data
  [
    {start_at: '20.11.2022 17:00', place: 'Al-Chaur', team1_name: 'Katar', team2_name: 'Ecuador', group: GROUP_A, round: GROUP},

    {start_at: '21.11.2022 14:00', place: 'Ar-Rayyan', team1_name: 'England', team2_name: 'Iran', group: GROUP_B, round: GROUP},
    {start_at: '21.11.2022 17:00', place: 'Doha', team1_name: 'Senegal', team2_name: 'Niederlande', group: GROUP_A, round: GROUP},
    {start_at: '21.11.2022 20:00', place: 'Ar-Rayyan', team1_name: 'USA', team2_name: 'Wales', group: GROUP_B, round: GROUP},

    {start_at: '22.11.2022 11:00', place: 'Lusail', team1_name: 'Argentinien', team2_name: 'Saudi-Arabien', group: GROUP_C, round: GROUP},
    {start_at: '22.11.2022 14:00', place: 'Doha', team1_name: 'Dänemark', team2_name: 'Tunesien', group: GROUP_D, round: GROUP},
    {start_at: '22.11.2022 17:00', place: 'Doha', team1_name: 'Mexiko', team2_name: 'Polen', group: GROUP_C, round: GROUP},
    {start_at: '22.11.2022 20:00', place: 'Al Wakrah', team1_name: 'Frankreich', team2_name: 'Australien', group: GROUP_D, round: GROUP},

    {start_at: '23.11.2022 11:00', place: 'Al-Chaur', team1_name: 'Marokko', team2_name: 'Kroatien', group: GROUP_F, round: GROUP},
    {start_at: '23.11.2022 14:00', place: 'Ar-Rayyan', team1_name: 'Deutschland', team2_name: 'Japan', group: GROUP_E, round: GROUP},
    {start_at: '23.11.2022 17:00', place: 'Doha', team1_name: 'Spanien', team2_name: 'Costa Rica', group: GROUP_E, round: GROUP},
    {start_at: '23.11.2022 20:00', place: 'Ar-Rayyan', team1_name: 'Belgien', team2_name: 'Kanada', group: GROUP_F, round: GROUP},

    {start_at: '24.11.2022 11:00', place: 'Al Wakrah', team1_name: 'Schweiz', team2_name: 'Kamerun', group: GROUP_G, round: GROUP},
    {start_at: '24.11.2022 14:00', place: 'Doha', team1_name: 'Uruguay', team2_name: 'Südkorea', group: GROUP_H, round: GROUP},
    {start_at: '24.11.2022 17:00', place: 'Doha', team1_name: 'Portugal', team2_name: 'Ghana', group: GROUP_H, round: GROUP},
    {start_at: '24.11.2022 20:00', place: 'Lusail', team1_name: 'Brasilien', team2_name: 'Serbien', group: GROUP_G, round: GROUP},

    {start_at: '25.11.2022 11:00', place: 'Ar-Rayyan', team1_name: 'Wales', team2_name: 'Iran', group: GROUP_B, round: GROUP},
    {start_at: '25.11.2022 14:00', place: 'Doha', team1_name: 'Katar', team2_name: 'Senegal', group: GROUP_A, round: GROUP},
    {start_at: '25.11.2022 17:00', place: 'Ar-Rayyan', team1_name: 'Niederlande', team2_name: 'Ecuador', group: GROUP_A, round: GROUP},
    {start_at: '25.11.2022 20:00', place: 'Al-Chaur', team1_name: 'England', team2_name: 'USA', group: GROUP_B, round: GROUP},

    {start_at: '26.11.2022 11:00', place: 'Al Wakrah', team1_name: 'Tunesien', team2_name: 'Australien', group: GROUP_D, round: GROUP},
    {start_at: '26.11.2022 14:00', place: 'Doha', team1_name: 'Polen', team2_name: 'Saudi-Arabien', group: GROUP_C, round: GROUP},
    {start_at: '26.11.2022 17:00', place: 'Doha', team1_name: 'Frankreich', team2_name: 'Dänemark', group: GROUP_D, round: GROUP},
    {start_at: '26.11.2022 20:00', place: 'Lusail', team1_name: 'Argentinien', team2_name: 'Mexiko', group: GROUP_C, round: GROUP},

    {start_at: '27.11.2022 11:00', place: 'Ar-Rayyan', team1_name: 'Japan', team2_name: 'Costa Rica', group: GROUP_E, round: GROUP},
    {start_at: '27.11.2022 14:00', place: 'Doha', team1_name: 'Belgien', team2_name: 'Marokko', group: GROUP_F, round: GROUP},
    {start_at: '27.11.2022 17:00', place: 'Ar-Rayyan', team1_name: 'Kroatien', team2_name: 'Kanada', group: GROUP_F, round: GROUP},
    {start_at: '27.11.2022 20:00', place: 'Al-Chaur', team1_name: 'Spanien', team2_name: 'Deutschland', group: GROUP_E, round: GROUP},

    {start_at: '28.11.2022 11:00', place: 'Al Wakrah', team1_name: 'Kamerun', team2_name: 'Serbien', group: GROUP_G, round: GROUP},
    {start_at: '28.11.2022 14:00', place: 'Doha', team1_name: 'Südkorea', team2_name: 'Ghana', group: GROUP_H, round: GROUP},
    {start_at: '28.11.2022 17:00', place: 'Doha', team1_name: 'Brasilien', team2_name: 'Schweiz', group: GROUP_G, round: GROUP},
    {start_at: '28.11.2022 20:00', place: 'Lusail', team1_name: 'Portugal', team2_name: 'Uruguay', group: GROUP_H, round: GROUP},

    {start_at: '29.11.2022 16:00', place: 'Al-Chaur', team1_name: 'Niederlande', team2_name: 'Katar', group: GROUP_A, round: GROUP},
    {start_at: '29.11.2022 16:00', place: 'Ar-Rayyan', team1_name: 'Ecuador', team2_name: 'Senegal', group: GROUP_A, round: GROUP},
    {start_at: '29.11.2022 20:00', place: 'Ar-Rayyan', team1_name: 'Wales', team2_name: 'England', group: GROUP_B, round: GROUP},
    {start_at: '29.11.2022 20:00', place: 'Doha', team1_name: 'Iran', team2_name: 'USA', group: GROUP_B, round: GROUP},

    {start_at: '30.11.2022 16:00', place: 'Al Wakrah', team1_name: 'Australien', team2_name: 'Dänemark', group: GROUP_D, round: GROUP},
    {start_at: '30.11.2022 16:00', place: 'Doha', team1_name: 'Tunesien', team2_name: 'Frankreich', group: GROUP_D, round: GROUP},
    {start_at: '30.11.2022 20:00', place: 'Doha', team1_name: 'Polen', team2_name: 'Argentinien', group: GROUP_C, round: GROUP},
    {start_at: '30.11.2022 20:00', place: 'Lusail', team1_name: 'Saudi-Arabien', team2_name: 'Mexiko', group: GROUP_C, round: GROUP},

    {start_at: '01.12.2022 16:00', place: 'Ar-Rayyan', team1_name: 'Kroatien', team2_name: 'Belgien', group: GROUP_F, round: GROUP},
    {start_at: '01.12.2022 16:00', place: 'Doha', team1_name: 'Kanada', team2_name: 'Marokko', group: GROUP_F, round: GROUP},
    {start_at: '01.12.2022 20:00', place: 'Ar-Rayyan', team1_name: 'Japan', team2_name: 'Spanien', group: GROUP_E, round: GROUP},
    {start_at: '01.12.2022 20:00', place: 'Al-Chaur', team1_name: 'Costa Rica', team2_name: 'Deutschland', group: GROUP_E, round: GROUP},

    {start_at: '02.12.2022 16:00', place: 'Al Wakrah', team1_name: 'Ghana', team2_name: 'Uruguay', group: GROUP_H, round: GROUP},
    {start_at: '02.12.2022 16:00', place: 'Doha', team1_name: 'Südkorea', team2_name: 'Portugal', group: GROUP_H, round: GROUP},
    {start_at: '02.12.2022 20:00', place: 'Doha', team1_name: 'Serbien', team2_name: 'Schweiz', group: GROUP_G, round: GROUP},
    {start_at: '02.12.2022 20:00', place: 'Lusail', team1_name: 'Kamerun', team2_name: 'Brasilien', group: GROUP_G, round: GROUP},

    # Achtelfinale
    {start_at: '03.12.2022 16:00', place: 'Ar-Rayyan', team1_placeholder_name: '1. Gruppe A', team2_placeholder_name: '2. Gruppe B', group: nil, round: ROUND_OF_16},
    {start_at: '03.12.2022 20:00', place: 'Ar-Rayyan', team1_placeholder_name: '1. Gruppe C', team2_placeholder_name: '2. Gruppe D', group: nil, round: ROUND_OF_16},

    {start_at: '04.12.2022 16:00', place: 'Doha', team1_placeholder_name: '1. Gruppe D', team2_placeholder_name: '2. Gruppe C', group: nil, round: ROUND_OF_16},
    {start_at: '04.12.2022 20:00', place: 'Al-Chaur', team1_placeholder_name: '1. Gruppe B', team2_placeholder_name: '2. Gruppe A', group: nil, round: ROUND_OF_16},

    {start_at: '05.12.2022 16:00', place: 'Al Wakrah', team1_placeholder_name: '1. Gruppe E', team2_placeholder_name: '2. Gruppe F', group: nil, round: ROUND_OF_16},
    {start_at: '05.12.2022 20:00', place: 'Doha', team1_placeholder_name: '1. Gruppe G', team2_placeholder_name: '2. Gruppe H', group: nil, round: ROUND_OF_16},

    {start_at: '06.12.2022 16:00', place: 'Doha', team1_placeholder_name: '1. Gruppe F', team2_placeholder_name: '2. Gruppe E', group: nil, round: ROUND_OF_16},
    {start_at: '06.12.2022 20:00', place: 'Lusail', team1_placeholder_name: '1. Gruppe H', team2_placeholder_name: '2. Gruppe G', group: nil, round: ROUND_OF_16},

    # Viertelfinale
    {start_at: '09.12.2022 16:00', place: 'Doha', team1_placeholder_name: 'Sieger AF 5', team2_placeholder_name: 'Sieger AF 6', group: nil, round: QUARTERFINAL},
    {start_at: '09.12.2022 20:00', place: 'Lusail', team1_placeholder_name: 'Sieger AF 1', team2_placeholder_name: 'Sieger AF 2', group: nil, round: QUARTERFINAL},
    {start_at: '10.12.2022 16:00', place: 'Doha', team1_placeholder_name: 'Sieger AF 7', team2_placeholder_name: 'Sieger AF 8', group: nil, round: QUARTERFINAL},
    {start_at: '10.12.2022 20:00', place: 'Al-Chaur', team1_placeholder_name: 'Sieger AF 3', team2_placeholder_name: 'Sieger AF 4', group: nil, round: QUARTERFINAL},

    # Halbfinale
    {start_at: '13.12.2022 20:00', place: 'Lusail', team1_placeholder_name: 'Sieger VF 1', team2_placeholder_name: 'Sieger VF 2', group: nil, round: SEMIFINAL},
    {start_at: '14.12.2022 20:00', place: 'Al-Chaur', team1_placeholder_name: 'Sieger VF 3', team2_placeholder_name: 'Sieger VF 4', group: nil, round: SEMIFINAL},

    # Spiel um Platz 3
    {start_at: '17.12.2022 16:00', place: 'Ar-Rayyan', team1_placeholder_name: 'Verlierer HF 1', team2_placeholder_name: 'Verlierer HF 2', group: nil, round: PLACE_3},

    # Finale
    {start_at: '18.12.2022 16:00', place: 'Lusail', team1_placeholder_name: 'Sieger HF 1', team2_placeholder_name: 'Sieger HF 2', group: nil, round: FINAL},
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

