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

# data from https://de.uefa.com/uefaeuro-2020/news/0253-0d820ec63626-e75859a771ad-1000--spielplan-der-uefa-euro-2020/
def game_data
  [
    {start_at: '11.06.2021 21:00', place: 'Rom', team1_name: 'Türkei', team2_name: 'Italien', group: GROUP_A, round: GROUP},

    {start_at: '12.06.2021 15:00', place: 'Baku', team1_name: 'Wales', team2_name: 'Schweiz', group: GROUP_A, round: GROUP},
    {start_at: '12.06.2021 18:00', place: 'Kopenhagen', team1_name: 'Dänemark', team2_name: 'Finnland', group: GROUP_B, round: GROUP},
    {start_at: '12.06.2021 21:00', place: 'St. Petersburg', team1_name: 'Belgien', team2_name: 'Russland', group: GROUP_B, round: GROUP},

    {start_at: '13.06.2021 15:00', place: 'London', team1_name: 'England', team2_name: 'Kroatien', group: GROUP_D, round: GROUP},
    {start_at: '13.06.2021 18:00', place: 'Bukarest', team1_name: 'Österreich', team2_name: 'Nordmazedonien', group: GROUP_C, round: GROUP},
    {start_at: '13.06.2021 21:00', place: 'Amsterdam', team1_name: 'Niederlande', team2_name: 'Ukraine', group: GROUP_C, round: GROUP},

    {start_at: '14.06.2021 15:00', place: 'Glasgow', team1_name: 'Schottland', team2_name: 'Tschechien', group: GROUP_D, round: GROUP},
    {start_at: '14.06.2021 18:00', place: 'St. Petersburg', team1_name: 'Polen', team2_name: 'Slowakei', group: GROUP_E, round: GROUP},
    {start_at: '14.06.2021 21:00', place: 'Sevilla', team1_name: 'Spanien', team2_name: 'Schweden', group: GROUP_E, round: GROUP},

    {start_at: '15.06.2021 18:00', place: 'Budapest', team1_name: 'Ungarn', team2_name: 'Portugal', group: GROUP_F, round: GROUP},
    {start_at: '15.06.2021 21:00', place: 'München', team1_name: 'Frankreich', team2_name: 'Deutschland', group: GROUP_F, round: GROUP},

    {start_at: '16.06.2021 15:00', place: 'St. Petersburg', team1_name: 'Finnland', team2_name: 'Russland', group: GROUP_B, round: GROUP},
    {start_at: '16.06.2021 18:00', place: 'Baku', team1_name: 'Türkei', team2_name: 'Wales', group: GROUP_A, round: GROUP},
    {start_at: '16.06.2021 21:00', place: 'Rom', team1_name: 'Italien', team2_name: 'Schweiz', group: GROUP_A, round: GROUP},

    {start_at: '17.06.2021 15:00', place: 'Bukarest', team1_name: 'Ukraine', team2_name: 'Nordmazedonien', group: GROUP_C, round: GROUP},
    {start_at: '17.06.2021 18:00', place: 'Kopenhagen', team1_name: 'Dänemark', team2_name: 'Belgien', group: GROUP_B, round: GROUP},
    {start_at: '17.06.2021 21:00', place: 'Amsterdam', team1_name: 'Niederlande', team2_name: 'Österreich', group: GROUP_C, round: GROUP},

    {start_at: '18.06.2021 15:00', place: 'St. Petersburg', team1_name: 'Schweden', team2_name: 'Slowakei', group: GROUP_E, round: GROUP},
    {start_at: '18.06.2021 18:00', place: 'Glasgow', team1_name: 'Kroatien', team2_name: 'Tschechien', group: GROUP_D, round: GROUP},
    {start_at: '18.06.2021 21:00', place: 'London', team1_name: 'England', team2_name: 'Schottland', group: GROUP_D, round: GROUP},

    {start_at: '19.06.2021 15:00', place: 'Budapest', team1_name: 'Ungarn', team2_name: 'Frankreich', group: GROUP_F, round: GROUP},
    {start_at: '19.06.2021 18:00', place: 'München', team1_name: 'Portugal', team2_name: 'Deutschland', group: GROUP_F, round: GROUP},
    {start_at: '19.06.2021 21:00', place: 'Sevilla', team1_name: 'Spanien', team2_name: 'Polen', group: GROUP_E, round: GROUP},

    {start_at: '20.06.2021 18:00', place: 'Rom', team1_name: 'Italien', team2_name: 'Wales', group: GROUP_A, round: GROUP},
    {start_at: '20.06.2021 18:00', place: 'Baku', team1_name: 'Schweiz', team2_name: 'Türkei', group: GROUP_A, round: GROUP},

    {start_at: '21.06.2021 18:00', place: 'Amsterdam', team1_name: 'Nordmazedonien', team2_name: 'Niederlande', group: GROUP_C, round: GROUP},
    {start_at: '21.06.2021 18:00', place: 'Bukarest', team1_name: 'Ukraine', team2_name: 'Österreich', group: GROUP_C, round: GROUP},
    {start_at: '21.06.2021 21:00', place: 'Kopenhagen', team1_name: 'Russland', team2_name: 'Dänemark', group: GROUP_B, round: GROUP},
    {start_at: '21.06.2021 21:00', place: 'St. Petersburg', team1_name: 'Finnland', team2_name: 'Belgien', group: GROUP_B, round: GROUP},

    {start_at: '22.06.2021 21:00', place: 'London', team1_name: 'Tschechien', team2_name: 'England', group: GROUP_D, round: GROUP},
    {start_at: '22.06.2021 21:00', place: 'Glasgow', team1_name: 'Kroatien', team2_name: 'Schottland', group: GROUP_D, round: GROUP},

    {start_at: '22.06.2021 18:00', place: 'Sevilla', team1_name: 'Slowakei', team2_name: 'Spanien', group: GROUP_E, round: GROUP},
    {start_at: '22.06.2021 18:00', place: 'St. Petersburg', team1_name: 'Schweden', team2_name: 'Polen', group: GROUP_E, round: GROUP},
    {start_at: '22.06.2021 21:00', place: 'München', team1_name: 'Deutschland', team2_name: 'Ungarn', group: GROUP_F, round: GROUP},
    {start_at: '22.06.2021 21:00', place: 'Budapest', team1_name: 'Portugal', team2_name: 'Frankreich', group: GROUP_F, round: GROUP},

    # Achtelfinale
    {start_at: '26.06.2021 18:00', place: 'Amsterdam', team1_placeholder_name: '2. Gruppe A', team2_placeholder_name: '2. Gruppe B', group: nil, round: ROUND_OF_16},
    {start_at: '26.06.2021 21:00', place: 'London', team1_placeholder_name: '1. Gruppe A', team2_placeholder_name: '2. Gruppe C', group: nil, round: ROUND_OF_16},

    {start_at: '27.06.2021 18:00', place: 'Budapest', team1_placeholder_name: '1. Gruppe C', team2_placeholder_name: '3. Gruppe D/E/F', group: nil, round: ROUND_OF_16},
    {start_at: '27.06.2021 21:00', place: 'Sevilla', team1_placeholder_name: '1. Gruppe B', team2_placeholder_name: '3. Gruppe A/D/E/F', group: nil, round: ROUND_OF_16},

    {start_at: '28.06.2021 18:00', place: 'Kopenhagen', team1_placeholder_name: '2. Gruppe D', team2_placeholder_name: '2. Gruppe E', group: nil, round: ROUND_OF_16},
    {start_at: '28.06.2021 21:00', place: 'Bukarest', team1_placeholder_name: '1. Gruppe F', team2_placeholder_name: '3. Gruppe A/B/C', group: nil, round: ROUND_OF_16},

    {start_at: '29.06.2021 18:00', place: 'London', team1_placeholder_name: '1. Gruppe D', team2_placeholder_name: '2. Gruppe F', group: nil, round: ROUND_OF_16},
    {start_at: '29.06.2021 21:00', place: 'Glasgow', team1_placeholder_name: '1. Gruppe E', team2_placeholder_name: '3. Gruppe A/B/C/D', group: nil, round: ROUND_OF_16},

    # Viertelfinale
    {start_at: '02.07.2021 18:00', place: 'St. Petersburg', team1_placeholder_name: 'Sieger AF 6', team2_placeholder_name: 'Sieger AF 5', group: nil, round: QUARTERFINAL},
    {start_at: '02.07.2021 21:00', place: 'München', team1_placeholder_name: 'Sieger AF 4', team2_placeholder_name: 'Sieger AF 2', group: nil, round: QUARTERFINAL},
    {start_at: '03.07.2021 18:00', place: 'Baku', team1_placeholder_name: 'Sieger AF 3', team2_placeholder_name: 'Sieger AF 1', group: nil, round: QUARTERFINAL},
    {start_at: '03.07.2021 21:00', place: 'Rom', team1_placeholder_name: 'Sieger AF 8', team2_placeholder_name: 'Sieger AF 7', group: nil, round: QUARTERFINAL},

    # Halbfinale
    {start_at: '06.07.2021 21:00', place: 'London', team1_placeholder_name: 'Sieger VF 2', team2_placeholder_name: 'Sieger VF 1', group: nil, round: SEMIFINAL},
    {start_at: '07.07.2021 21:00', place: 'London', team1_placeholder_name: 'Sieger VF 4', team2_placeholder_name: 'Sieger VF 3', group: nil, round: SEMIFINAL},

    # Finale
    {start_at: '11.07.2021 21:00', place: 'London', team1_placeholder_name: 'Sieger HF 1', team2_placeholder_name: 'Sieger HF 2', group: nil, round: FINAL},
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

