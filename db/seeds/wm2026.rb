# frozen_string_literal: true

# WM 2026 seed data — extracted for testability.
# Used by db/seeds.rb and spec/db/seeds_spec.rb.
module Seeds
  module Wm2026
    # flags from https://github.com/lafeber/world-flags-sprite
    # ISO 3166-1 alpha-2 codes: http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
    def self.country_code_map
      {
        'Ägypten'               => 'eg',
        'Albanien'              => 'al',
        'Algerien'              => 'dz',
        'Argentinien'           => 'ar',
        'Australien'            => 'au',
        'Belgien'               => 'be',
        'Bosnien-Herzegowina'   => 'ba',
        'Brasilien'             => 'br',
        'Chile'                 => 'cl',
        'Costa Rica'            => 'cr',
        'Curaçao'               => 'cw',
        'Dänemark'              => 'dk',
        'Deutschland'           => 'de',
        'DR Kongo'              => 'cd',
        'Ecuador'               => 'ec',
        'Elfenbeinküste'        => 'ci',
        'England'               => '_England',
        'Finnland'              => 'fi',
        'Frankreich'            => 'fr',
        'Georgien'              => 'ge',
        'Ghana'                 => 'gh',
        'Griechenland'          => 'gr',
        'Haiti'                 => 'ht',
        'Honduras'              => 'hn',
        'Iran'                  => 'ir',
        'Irak'                  => 'iq',
        'Irland'                => 'ie',
        'Island'                => 'is',
        'Italien'               => 'it',
        'Japan'                 => 'jp',
        'Jordanien'             => 'jo',
        'Kamerun'               => 'cm',
        'Kanada'                => 'ca',
        'Kap Verde'             => 'cv',
        'Katar'                 => 'qa',
        'Kolumbien'             => 'co',
        'Kroatien'              => 'hr',
        'Marokko'               => 'ma',
        'Mexiko'                => 'mx',
        'Neuseeland'            => 'nz',
        'Niederlande'           => 'nl',
        'Nigeria'               => 'ng',
        'Nordirland'            => '_Northern_Ireland',
        'Nordmazedonien'        => 'mk',
        'Norwegen'              => 'no',
        'Österreich'            => 'at',
        'Panama'                => 'pa',
        'Paraguay'              => 'py',
        'Peru'                  => 'pe',
        'Polen'                 => 'pl',
        'Portugal'              => 'pt',
        'Rumänien'              => 'ro',
        'Russland'              => 'ru',
        'Saudi-Arabien'         => 'sa',
        'Schottland'            => '_Scotland',
        'Schweden'              => 'se',
        'Schweiz'               => 'ch',
        'Senegal'               => 'sn',
        'Serbien'               => 'rs',
        'Slowakei'              => 'sk',
        'Slowenien'             => 'si',
        'Spanien'               => 'es',
        'Südkorea'              => 'kr',
        'Südafrika'             => 'za',
        'Tschechien'            => 'cz',
        'Tunesien'              => 'tn',
        'Türkei'                => 'tr',
        'Ukraine'               => 'ua',
        'Ungarn'                => 'hu',
        'Uruguay'               => 'uy',
        'USA'                   => 'us',
        'Usbekistan'            => 'uz',
        'Wales'                 => '_Wales'
      }
    end

    # WM 2026 — Canada, USA, Mexico
    # 48 teams, 12 groups (A-L), 104 games
    # All times in CEST (UTC+2) — tournament runs in European summer
    # Sources:
    #   https://github.com/openfootball/worldcup/tree/master/2026--usa
    #   https://www.fifa.com/en/tournaments/mens/worldcup/canadamexicousa2026
    #
    # UTC offsets converted to CEST (UTC+2):
    #   UTC-6 (CDT Mexico)       → +8h
    #   UTC-7 (PDT West Coast)   → +9h
    #   UTC-5 (CDT Central US)   → +7h
    #   UTC-4 (EDT East Coast)   → +6h
    def self.game_data
      [
        # ── Group A: Mexiko, Südafrika, Südkorea, Tschechien ──────────────────
        {start_at: '11.06.2026 21:00', place: 'Mexico City',    team1_name: 'Mexiko',    team2_name: 'Südafrika',  group: 'A', round: 'group'},
        {start_at: '12.06.2026 05:00', place: 'Guadalajara',     team1_name: 'Südkorea',  team2_name: 'Tschechien', group: 'A', round: 'group'},
        {start_at: '18.06.2026 20:00', place: 'Atlanta',         team1_name: 'Tschechien',team2_name: 'Südafrika',  group: 'A', round: 'group'},
        {start_at: '19.06.2026 03:00', place: 'Guadalajara',     team1_name: 'Mexiko',    team2_name: 'Südkorea',   group: 'A', round: 'group'},
        {start_at: '25.06.2026 03:00', place: 'Mexico City',    team1_name: 'Tschechien',team2_name: 'Mexiko',     group: 'A', round: 'group'},
        {start_at: '25.06.2026 03:00', place: 'Monterrey',       team1_name: 'Südafrika', team2_name: 'Südkorea',   group: 'A', round: 'group'},

        # ── Group B: Kanada, Bosnien-Herzegowina, Katar, Schweiz ──────────────
        {start_at: '12.06.2026 21:00', place: 'Toronto',         team1_name: 'Kanada',             team2_name: 'Bosnien-Herzegowina', group: 'B', round: 'group'},
        {start_at: '13.06.2026 21:00', place: 'San Francisco',   team1_name: 'Katar',              team2_name: 'Schweiz',            group: 'B', round: 'group'},
        {start_at: '18.06.2026 21:00', place: 'Los Angeles',     team1_name: 'Schweiz',            team2_name: 'Bosnien-Herzegowina', group: 'B', round: 'group'},
        {start_at: '19.06.2026 00:00', place: 'Vancouver',       team1_name: 'Kanada',             team2_name: 'Katar',              group: 'B', round: 'group'},
        {start_at: '25.06.2026 21:00', place: 'Vancouver',       team1_name: 'Schweiz',            team2_name: 'Kanada',             group: 'B', round: 'group'},
        {start_at: '25.06.2026 21:00', place: 'Seattle',         team1_name: 'Bosnien-Herzegowina',team2_name: 'Katar',              group: 'B', round: 'group'},

        # ── Group C: Brasilien, Marokko, Haiti, Schottland ────────────────────
        {start_at: '14.06.2026 00:00', place: 'New York',        team1_name: 'Brasilien', team2_name: 'Marokko',   group: 'C', round: 'group'},
        {start_at: '14.06.2026 03:00', place: 'Boston',          team1_name: 'Haiti',     team2_name: 'Schottland',group: 'C', round: 'group'},
        {start_at: '20.06.2026 00:00', place: 'Boston',          team1_name: 'Schottland',team2_name: 'Marokko',   group: 'C', round: 'group'},
        {start_at: '20.06.2026 03:00', place: 'Philadelphia',    team1_name: 'Brasilien', team2_name: 'Haiti',     group: 'C', round: 'group'},
        {start_at: '25.06.2026 00:00', place: 'Miami',           team1_name: 'Schottland',team2_name: 'Brasilien', group: 'C', round: 'group'},
        {start_at: '25.06.2026 00:00', place: 'Atlanta',         team1_name: 'Marokko',   team2_name: 'Haiti',     group: 'C', round: 'group'},

        # ── Group D: USA, Paraguay, Australien, Türkei ────────────────────────
        {start_at: '13.06.2026 03:00', place: 'Los Angeles',     team1_name: 'USA',       team2_name: 'Paraguay',  group: 'D', round: 'group'},
        {start_at: '14.06.2026 06:00', place: 'Vancouver',       team1_name: 'Australien',team2_name: 'Türkei',    group: 'D', round: 'group'},
        {start_at: '19.06.2026 21:00', place: 'Seattle',         team1_name: 'USA',       team2_name: 'Australien',group: 'D', round: 'group'},
        {start_at: '20.06.2026 06:00', place: 'San Francisco',   team1_name: 'Türkei',    team2_name: 'Paraguay',  group: 'D', round: 'group'},
        {start_at: '26.06.2026 04:00', place: 'Los Angeles',     team1_name: 'Türkei',    team2_name: 'USA',       group: 'D', round: 'group'},
        {start_at: '26.06.2026 04:00', place: 'San Francisco',   team1_name: 'Paraguay',  team2_name: 'Australien',group: 'D', round: 'group'},

        # ── Group E: Deutschland, Curaçao, Elfenbeinküste, Ecuador ───────────
        {start_at: '14.06.2026 19:00', place: 'Houston',         team1_name: 'Deutschland',   team2_name: 'Curaçao',       group: 'E', round: 'group'},
        {start_at: '15.06.2026 01:00', place: 'Philadelphia',    team1_name: 'Elfenbeinküste',team2_name: 'Ecuador',       group: 'E', round: 'group'},
        {start_at: '20.06.2026 22:00', place: 'Toronto',         team1_name: 'Deutschland',   team2_name: 'Elfenbeinküste',group: 'E', round: 'group'},
        {start_at: '21.06.2026 02:00', place: 'Kansas City',     team1_name: 'Ecuador',       team2_name: 'Curaçao',       group: 'E', round: 'group'},
        {start_at: '26.06.2026 22:00', place: 'Philadelphia',    team1_name: 'Curaçao',       team2_name: 'Elfenbeinküste',group: 'E', round: 'group'},
        {start_at: '26.06.2026 22:00', place: 'New York',        team1_name: 'Ecuador',       team2_name: 'Deutschland',   group: 'E', round: 'group'},

        # ── Group F: Niederlande, Japan, Schweden, Tunesien ───────────────────
        {start_at: '14.06.2026 22:00', place: 'Dallas',          team1_name: 'Niederlande',team2_name: 'Japan',    group: 'F', round: 'group'},
        {start_at: '15.06.2026 04:00', place: 'Monterrey',       team1_name: 'Schweden',   team2_name: 'Tunesien', group: 'F', round: 'group'},
        {start_at: '20.06.2026 19:00', place: 'Houston',         team1_name: 'Niederlande',team2_name: 'Schweden', group: 'F', round: 'group'},
        {start_at: '21.06.2026 05:00', place: 'Monterrey',       team1_name: 'Tunesien',   team2_name: 'Japan',    group: 'F', round: 'group'},
        {start_at: '26.06.2026 01:00', place: 'Dallas',          team1_name: 'Japan',      team2_name: 'Schweden', group: 'F', round: 'group'},
        {start_at: '26.06.2026 01:00', place: 'Kansas City',     team1_name: 'Tunesien',   team2_name: 'Niederlande',group: 'F', round: 'group'},

        # ── Group G: Belgien, Ägypten, Iran, Neuseeland ───────────────────────
        {start_at: '15.06.2026 21:00', place: 'Seattle',         team1_name: 'Belgien',   team2_name: 'Ägypten',   group: 'G', round: 'group'},
        {start_at: '16.06.2026 03:00', place: 'Los Angeles',     team1_name: 'Iran',      team2_name: 'Neuseeland',group: 'G', round: 'group'},
        {start_at: '21.06.2026 21:00', place: 'Los Angeles',     team1_name: 'Belgien',   team2_name: 'Iran',      group: 'G', round: 'group'},
        {start_at: '22.06.2026 03:00', place: 'Vancouver',       team1_name: 'Neuseeland',team2_name: 'Ägypten',   group: 'G', round: 'group'},
        {start_at: '27.06.2026 03:00', place: 'Seattle',         team1_name: 'Ägypten',   team2_name: 'Iran',      group: 'G', round: 'group'},
        {start_at: '27.06.2026 03:00', place: 'Vancouver',       team1_name: 'Neuseeland',team2_name: 'Belgien',   group: 'G', round: 'group'},

        # ── Group H: Spanien, Kap Verde, Saudi-Arabien, Uruguay ──────────────
        {start_at: '15.06.2026 18:00', place: 'Atlanta',         team1_name: 'Spanien',      team2_name: 'Kap Verde',    group: 'H', round: 'group'},
        {start_at: '16.06.2026 00:00', place: 'Miami',           team1_name: 'Saudi-Arabien',team2_name: 'Uruguay',      group: 'H', round: 'group'},
        {start_at: '21.06.2026 18:00', place: 'Atlanta',         team1_name: 'Spanien',      team2_name: 'Saudi-Arabien',group: 'H', round: 'group'},
        {start_at: '22.06.2026 00:00', place: 'Miami',           team1_name: 'Uruguay',      team2_name: 'Kap Verde',    group: 'H', round: 'group'},
        {start_at: '27.06.2026 01:00', place: 'Houston',         team1_name: 'Kap Verde',    team2_name: 'Saudi-Arabien',group: 'H', round: 'group'},
        {start_at: '27.06.2026 00:00', place: 'Guadalajara',     team1_name: 'Uruguay',      team2_name: 'Spanien',      group: 'H', round: 'group'},

        # ── Group I: Frankreich, Senegal, Irak, Norwegen ─────────────────────
        {start_at: '16.06.2026 21:00', place: 'New York',        team1_name: 'Frankreich',team2_name: 'Senegal', group: 'I', round: 'group'},
        {start_at: '17.06.2026 00:00', place: 'Boston',          team1_name: 'Irak',      team2_name: 'Norwegen',group: 'I', round: 'group'},
        {start_at: '22.06.2026 23:00', place: 'Philadelphia',    team1_name: 'Frankreich',team2_name: 'Irak',    group: 'I', round: 'group'},
        {start_at: '23.06.2026 02:00', place: 'New York',        team1_name: 'Norwegen',  team2_name: 'Senegal', group: 'I', round: 'group'},
        {start_at: '27.06.2026 21:00', place: 'Boston',          team1_name: 'Norwegen',  team2_name: 'Frankreich',group: 'I', round: 'group'},
        {start_at: '27.06.2026 21:00', place: 'Toronto',         team1_name: 'Senegal',   team2_name: 'Irak',    group: 'I', round: 'group'},

        # ── Group J: Argentinien, Algerien, Österreich, Jordanien ────────────
        {start_at: '17.06.2026 02:00', place: 'Kansas City',     team1_name: 'Argentinien',team2_name: 'Algerien',  group: 'J', round: 'group'},
        {start_at: '17.06.2026 06:00', place: 'San Francisco',   team1_name: 'Österreich', team2_name: 'Jordanien', group: 'J', round: 'group'},
        {start_at: '22.06.2026 19:00', place: 'Dallas',          team1_name: 'Argentinien',team2_name: 'Österreich',group: 'J', round: 'group'},
        {start_at: '23.06.2026 05:00', place: 'San Francisco',   team1_name: 'Jordanien',  team2_name: 'Algerien',  group: 'J', round: 'group'},
        {start_at: '28.06.2026 03:00', place: 'Kansas City',     team1_name: 'Algerien',   team2_name: 'Österreich',group: 'J', round: 'group'},
        {start_at: '28.06.2026 03:00', place: 'Dallas',          team1_name: 'Jordanien',  team2_name: 'Argentinien',group: 'J', round: 'group'},

        # ── Group K: Portugal, DR Kongo, Usbekistan, Kolumbien ───────────────
        {start_at: '17.06.2026 19:00', place: 'Houston',         team1_name: 'Portugal',  team2_name: 'DR Kongo',  group: 'K', round: 'group'},
        {start_at: '18.06.2026 02:00', place: 'Mexico City',    team1_name: 'Usbekistan',team2_name: 'Kolumbien', group: 'K', round: 'group'},
        {start_at: '23.06.2026 19:00', place: 'Houston',         team1_name: 'Portugal',  team2_name: 'Usbekistan',group: 'K', round: 'group'},
        {start_at: '24.06.2026 02:00', place: 'Guadalajara',     team1_name: 'Kolumbien', team2_name: 'DR Kongo',  group: 'K', round: 'group'},
        {start_at: '28.06.2026 01:30', place: 'Miami',           team1_name: 'Kolumbien', team2_name: 'Portugal',  group: 'K', round: 'group'},
        {start_at: '28.06.2026 01:30', place: 'Atlanta',         team1_name: 'DR Kongo',  team2_name: 'Usbekistan',group: 'K', round: 'group'},

        # ── Group L: England, Kroatien, Ghana, Panama ────────────────────────
        {start_at: '17.06.2026 22:00', place: 'Dallas',          team1_name: 'England',  team2_name: 'Kroatien', group: 'L', round: 'group'},
        {start_at: '18.06.2026 01:00', place: 'Toronto',         team1_name: 'Ghana',    team2_name: 'Panama',   group: 'L', round: 'group'},
        {start_at: '23.06.2026 22:00', place: 'Boston',          team1_name: 'England',  team2_name: 'Ghana',    group: 'L', round: 'group'},
        {start_at: '24.06.2026 01:00', place: 'Toronto',         team1_name: 'Panama',   team2_name: 'Kroatien', group: 'L', round: 'group'},
        {start_at: '27.06.2026 23:00', place: 'New York',        team1_name: 'Panama',   team2_name: 'England',  group: 'L', round: 'group'},
        {start_at: '27.06.2026 23:00', place: 'Philadelphia',    team1_name: 'Kroatien', team2_name: 'Ghana',    group: 'L', round: 'group'},

        # ── Round of 32 (match numbers 73-88) ────────────────────────────────
        {start_at: '28.06.2026 21:00', place: 'Los Angeles',     team1_placeholder_name: '2A',         team2_placeholder_name: '2B',         group: nil, round: 'roundof32'},
        {start_at: '29.06.2026 22:30', place: 'Boston',          team1_placeholder_name: '1E',         team2_placeholder_name: '3A/B/C/D/F', group: nil, round: 'roundof32'},
        {start_at: '30.06.2026 01:00', place: 'Monterrey',       team1_placeholder_name: '1F',         team2_placeholder_name: '2C',         group: nil, round: 'roundof32'},
        {start_at: '29.06.2026 19:00', place: 'Houston',         team1_placeholder_name: '1C',         team2_placeholder_name: '2F',         group: nil, round: 'roundof32'},
        {start_at: '30.06.2026 23:00', place: 'New York',        team1_placeholder_name: '1I',         team2_placeholder_name: '3C/D/F/G/H', group: nil, round: 'roundof32'},
        {start_at: '30.06.2026 19:00', place: 'Dallas',          team1_placeholder_name: '2E',         team2_placeholder_name: '2I',         group: nil, round: 'roundof32'},
        {start_at: '01.07.2026 01:00', place: 'Mexico City',    team1_placeholder_name: '1A',         team2_placeholder_name: '3C/E/F/H/I', group: nil, round: 'roundof32'},
        {start_at: '01.07.2026 18:00', place: 'Atlanta',         team1_placeholder_name: '1L',         team2_placeholder_name: '3E/H/I/J/K', group: nil, round: 'roundof32'},
        {start_at: '02.07.2026 02:00', place: 'San Francisco',   team1_placeholder_name: '1D',         team2_placeholder_name: '3B/E/F/I/J', group: nil, round: 'roundof32'},
        {start_at: '01.07.2026 23:00', place: 'Seattle',         team1_placeholder_name: '1G',         team2_placeholder_name: '3A/E/H/I/J', group: nil, round: 'roundof32'},
        {start_at: '02.07.2026 03:00', place: 'Toronto',         team1_placeholder_name: '2K',         team2_placeholder_name: '2L',         group: nil, round: 'roundof32'},
        {start_at: '02.07.2026 23:00', place: 'Los Angeles',     team1_placeholder_name: '1H',         team2_placeholder_name: '2J',         group: nil, round: 'roundof32'},
        {start_at: '04.07.2026 03:00', place: 'Vancouver',       team1_placeholder_name: '1B',         team2_placeholder_name: '3E/F/G/I/J', group: nil, round: 'roundof32'},
        {start_at: '03.07.2026 02:00', place: 'Miami',           team1_placeholder_name: '1J',         team2_placeholder_name: '2H',         group: nil, round: 'roundof32'},
        {start_at: '04.07.2026 03:30', place: 'Kansas City',     team1_placeholder_name: '1K',         team2_placeholder_name: '3D/E/I/J/L', group: nil, round: 'roundof32'},
        {start_at: '03.07.2026 21:00', place: 'Dallas',          team1_placeholder_name: '2D',         team2_placeholder_name: '2G',         group: nil, round: 'roundof32'},

        # ── Round of 16 (match numbers 89-96) ────────────────────────────────
        {start_at: '05.07.2026 23:00', place: 'Philadelphia',    team1_placeholder_name: '-', team2_placeholder_name: '-', group: nil, round: 'roundof16'},
        {start_at: '05.07.2026 19:00', place: 'Houston',         team1_placeholder_name: '-', team2_placeholder_name: '-', group: nil, round: 'roundof16'},
        {start_at: '06.07.2026 22:00', place: 'New York',        team1_placeholder_name: '-', team2_placeholder_name: '-', group: nil, round: 'roundof16'},
        {start_at: '07.07.2026 02:00', place: 'Mexico City',    team1_placeholder_name: '-', team2_placeholder_name: '-', group: nil, round: 'roundof16'},
        {start_at: '07.07.2026 21:00', place: 'Dallas',          team1_placeholder_name: '-', team2_placeholder_name: '-', group: nil, round: 'roundof16'},
        {start_at: '07.07.2026 23:00', place: 'Seattle',         team1_placeholder_name: '-', team2_placeholder_name: '-', group: nil, round: 'roundof16'},
        {start_at: '08.07.2026 18:00', place: 'Atlanta',         team1_placeholder_name: '-', team2_placeholder_name: '-', group: nil, round: 'roundof16'},
        {start_at: '08.07.2026 23:00', place: 'Vancouver',       team1_placeholder_name: '-', team2_placeholder_name: '-', group: nil, round: 'roundof16'},

        # ── Quarter-finals (match numbers 97-100) ────────────────────────────
        {start_at: '10.07.2026 22:00', place: 'Boston',          team1_placeholder_name: '-', team2_placeholder_name: '-', group: nil, round: 'quarterfinal'},
        {start_at: '11.07.2026 21:00', place: 'Los Angeles',     team1_placeholder_name: '-', team2_placeholder_name: '-', group: nil, round: 'quarterfinal'},
        {start_at: '11.07.2026 23:00', place: 'Miami',           team1_placeholder_name: '-', team2_placeholder_name: '-', group: nil, round: 'quarterfinal'},
        {start_at: '12.07.2026 02:00', place: 'Kansas City',     team1_placeholder_name: '-', team2_placeholder_name: '-', group: nil, round: 'quarterfinal'},

        # ── Semi-finals (match numbers 101-102) ──────────────────────────────
        {start_at: '14.07.2026 21:00', place: 'Dallas',          team1_placeholder_name: '-', team2_placeholder_name: '-', group: nil, round: 'semifinal'},
        {start_at: '16.07.2026 21:00', place: 'Atlanta',         team1_placeholder_name: '-', team2_placeholder_name: '-', group: nil, round: 'semifinal'},

        # ── Third place match ─────────────────────────────────────────────────
        {start_at: '18.07.2026 23:00', place: 'Miami',           team1_placeholder_name: '-', team2_placeholder_name: '-', group: nil, round: 'place3'},

        # ── Final ─────────────────────────────────────────────────────────────
        {start_at: '19.07.2026 21:00', place: 'New York',        team1_placeholder_name: '-', team2_placeholder_name: '-', group: nil, round: 'final'},
      ]
    end
  end
end
