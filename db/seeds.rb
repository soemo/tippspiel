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
      'Georgien' => 'ge',
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
      'Slowenien' => 'si',
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
# EM2024 https://de.wikipedia.org/wiki/Fu%C3%9Fball-Europameisterschaft_2024, and https://de.uefa.com/euro2024/fixtures-results/#/d/2024-06-14
def game_data
  [
    {start_at: '14.06.2024 21:00', place: 'München', team1_name: 'Deutschland', team2_name: 'Schottland', group: GROUP_A, round: GROUP},
    {start_at: '15.06.2024 15:00', place: 'Köln', team1_name: 'Ungarn', team2_name: 'Schweiz', group: GROUP_A, round: GROUP},
    {start_at: '15.06.2024 18:00', place: 'Berlin', team1_name: 'Spanien', team2_name: 'Kroatien', group: GROUP_B, round: GROUP},
    {start_at: '15.06.2024 21:00', place: 'Dortmund', team1_name: 'Italien', team2_name: 'Albanien', group: GROUP_B, round: GROUP},
    {start_at: '16.06.2024 21:00', place: 'Gelsenkirchen', team1_name: 'Serbien', team2_name: 'England', group: GROUP_C, round: GROUP},
    {start_at: '16.06.2024 18:00', place: 'Stuttgart', team1_name: 'Slowenien', team2_name: 'Dänemark', group: GROUP_C, round: GROUP},
    {start_at: '16.06.2024 15:00', place: 'Hamburg', team1_name: 'Polen', team2_name: 'Niederlande', group: GROUP_D, round: GROUP},
    {start_at: '17.06.2024 21:00', place: 'Düsseldorf', team1_name: 'Österreich', team2_name: 'Frankreich', group: GROUP_D, round: GROUP},
    {start_at: '17.06.2024 18:00', place: 'Frankfurt', team1_name: 'Belgien', team2_name: 'Slowakei', group: GROUP_E, round: GROUP},
    {start_at: '17.06.2024 15:00', place: 'München', team1_name: 'Rumänien', team2_name: 'Ukraine', group: GROUP_E, round: GROUP},
    {start_at: '18.06.2024 18:00', place: 'Dortmund', team1_name: 'Türkei', team2_name: 'Georgien', group: GROUP_F, round: GROUP},
    {start_at: '18.06.2024 21:00', place: 'Leipzig', team1_name: 'Portugal', team2_name: 'Tschechien', group: GROUP_F, round: GROUP},
    {start_at: '19.06.2024 21:00', place: 'Köln', team1_name: 'Schottland', team2_name: 'Schweiz', group: GROUP_A, round: GROUP},
    {start_at: '19.06.2024 18:00', place: 'Stuttgart', team1_name: 'Deutschland', team2_name: 'Ungarn', group: GROUP_A, round: GROUP},
    {start_at: '19.06.2024 15:00', place: 'Hamburg', team1_name: 'Kroatien', team2_name: 'Albanien', group: GROUP_B, round: GROUP},
    {start_at: '20.06.2024 21:00', place: 'Gelsenkirchen', team1_name: 'Spanien', team2_name: 'Italien', group: GROUP_B, round: GROUP},
    {start_at: '20.06.2024 18:00', place: 'Frankfurt', team1_name: 'Dänemark', team2_name: 'England', group: GROUP_C, round: GROUP},
    {start_at: '20.06.2024 15:00', place: 'München', team1_name: 'Slowenien', team2_name: 'Serbien', group: GROUP_C, round: GROUP},
    {start_at: '21.06.2024 18:00', place: 'Berlin', team1_name: 'Polen', team2_name: 'Österreich', group: GROUP_D, round: GROUP},
    {start_at: '21.06.2024 21:00', place: 'Leipzig', team1_name: 'Niederlande', team2_name: 'Frankreich', group: GROUP_D, round: GROUP},
    {start_at: '21.06.2024 15:00', place: 'Düsseldorf', team1_name: 'Slowakei', team2_name: 'Ukraine', group: GROUP_E, round: GROUP},
    {start_at: '22.06.2024 21:00', place: 'Köln', team1_name: 'Belgien', team2_name: 'Rumänien', group: GROUP_E, round: GROUP},
    {start_at: '22.06.2024 18:00', place: 'Dortmund', team1_name: 'Türkei', team2_name: 'Portugal', group: GROUP_F, round: GROUP},
    {start_at: '22.06.2024 15:00', place: 'Hamburg', team1_name: 'Georgien', team2_name: 'Tschechien', group: GROUP_F, round: GROUP},
    {start_at: '23.06.2024 21:00', place: 'Frankfurt', team1_name: 'Schweiz', team2_name: 'Deutschland', group: GROUP_A, round: GROUP},
    {start_at: '23.06.2024 21:00', place: 'Stuttgart', team1_name: 'Schottland', team2_name: 'Ungarn', group: GROUP_A, round: GROUP},
    {start_at: '24.06.2024 21:00', place: 'Düsseldorf', team1_name: 'Albanien', team2_name: 'Spanien', group: GROUP_B, round: GROUP},
    {start_at: '24.06.2024 21:00', place: 'Leipzig', team1_name: 'Kroatien', team2_name: 'Italien', group: GROUP_B, round: GROUP},
    {start_at: '25.06.2024 21:00', place: 'Köln', team1_name: 'England', team2_name: 'Slowenien', group: GROUP_C, round: GROUP},
    {start_at: '25.06.2024 21:00', place: 'München', team1_name: 'Dänemark', team2_name: 'Serbien', group: GROUP_C, round: GROUP},
    {start_at: '25.06.2024 18:00', place: 'Berlin', team1_name: 'Niederlande', team2_name: 'Österreich', group: GROUP_D, round: GROUP},
    {start_at: '25.06.2024 18:00', place: 'Dortmund', team1_name: 'Frankreich', team2_name: 'Polen', group: GROUP_D, round: GROUP},
    {start_at: '26.06.2024 18:00', place: 'Frankfurt', team1_name: 'Slowakei', team2_name: 'Rumänien', group: GROUP_E, round: GROUP},
    {start_at: '26.06.2024 18:00', place: 'Stuttgart', team1_name: 'Ukraine', team2_name: 'Belgien', group: GROUP_E, round: GROUP},
    {start_at: '26.06.2024 21:00', place: 'Gelsenkirchen', team1_name: 'Georgien', team2_name: 'Portugal', group: GROUP_F, round: GROUP},
    {start_at: '26.06.2024 21:00', place: 'Hamburg', team1_name: 'Tschechien', team2_name: 'Türkei', group: GROUP_F, round: GROUP},
    {start_at: '29.06.2024 21:00', place: 'Dortmund', team1_placeholder_name: '1A', team2_placeholder_name: '2C', group: nil, round: ROUND_OF_16},
    {start_at: '29.06.2024 18:00', place: 'Berlin', team1_placeholder_name: '2A', team2_placeholder_name: '2B', group: nil, round: ROUND_OF_16},
    {start_at: '30.06.2024 21:00', place: 'Köln', team1_placeholder_name: '1B', team2_placeholder_name: '3ADEF', group: nil, round: ROUND_OF_16},
    {start_at: '30.06.2024 18:00', place: 'Gelsenkirchen', team1_placeholder_name: '1C', team2_placeholder_name: '3DEF', group: nil, round: ROUND_OF_16},
    {start_at: '01.07.2024 21:00', place: 'Frankfurt', team1_placeholder_name: '1F', team2_placeholder_name: '3ABC', group: nil, round: ROUND_OF_16},
    {start_at: '01.07.2024 18:00', place: 'Düsseldorf', team1_placeholder_name: '2D', team2_placeholder_name: '2E', group: nil, round: ROUND_OF_16},
    {start_at: '02.07.2024 18:00', place: 'München', team1_placeholder_name: '1E', team2_placeholder_name: '3ABCD', group: nil, round: ROUND_OF_16},
    {start_at: '02.07.2024 21:00', place: 'Leipzig', team1_placeholder_name: '1D', team2_placeholder_name: '2F', group: nil, round: ROUND_OF_16},
    {start_at: '05.07.2024 18:00', place: 'Stuttgart', team1_placeholder_name: '-', team2_placeholder_name: '-', group: nil, round: QUARTERFINAL},
    {start_at: '05.07.2024 21:00', place: 'Hamburg', team1_placeholder_name: '-', team2_placeholder_name: '-', group: nil, round: QUARTERFINAL},
    {start_at: '06.07.2024 21:00', place: 'Berlin', team1_placeholder_name: '-', team2_placeholder_name: '-', group: nil, round: QUARTERFINAL},
    {start_at: '06.07.2024 18:00', place: 'Düsseldorf', team1_placeholder_name: '-', team2_placeholder_name: '-', group: nil, round: QUARTERFINAL},
    {start_at: '09.07.2024 21:00', place: 'München', team1_placeholder_name: '-', team2_placeholder_name: '-', group: nil, round: SEMIFINAL},
    {start_at: '10.07.2024 21:00', place: 'Dortmund', team1_placeholder_name: '-', team2_placeholder_name: '-', group: nil, round: SEMIFINAL},
    {start_at: '14.07.2024 21:00', place: 'Berlin', team1_placeholder_name: '-', team2_placeholder_name: '-', group: nil, round: FINAL},
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

