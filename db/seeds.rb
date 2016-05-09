def clear_games
  # Games Tabellen wird gelöscht
  ActiveRecord::Base.connection.execute('TRUNCATE games')
end

# Die Flagen kommen von https://github.com/lafeber/world-flags-sprite
# The countries corresponding to the codes can be found at http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
# http://de.wikipedia.org/wiki/ISO-3166-1-Kodierliste
def country_code_map
  {
      'Albanien' => 'al',
      'Algerien' => 'dz',
      'Argentinien' => 'ar',
      'Australien' => 'au',
      'Belgien' => 'be',
      'Bosnien-Herzegowina' => 'ba',
      'Brasilien' => 'br',
      'Chile' => 'cl',
      'Costa Rica' => 'cr',
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
      'Mexiko' => 'mx',
      'Niederlande' => 'nl',
      'Nigeria' => 'ng',
      'Nordirland' => '_Northern_Ireland',
      'Österreich' => 'at',
      'Polen' => 'pl',
      'Portugal' => 'pt',
      'Rumänien' => 'ro',
      'Russland' => 'ru',
      'Schweden' => 'se',
      'Schweiz' => 'ch',
      'Slowakei' => 'sk',
      'Spanien' => 'es',
      'Südkorea' => 'kr',
      'Tschechien' => 'cz',
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
      {:start_at => '10.06.2016 21:00', :place => 'Saint-Denis', :team1_name => 'Frankreich', :team2_name => 'Rumänien', :group=> GROUP_A, :round => GROUP},
      {:start_at => '11.06.2016 15:00', :place => 'Lens', :team1_name => 'Albanien', :team2_name => 'Schweiz', :group=> GROUP_A, :round => GROUP},
      {:start_at => '15.06.2016 18:00', :place => 'Paris', :team1_name => 'Rumänien', :team2_name => 'Schweiz', :group=> GROUP_A, :round => GROUP},
      {:start_at => '15.06.2016 21:00', :place => 'Marseille', :team1_name => 'Frankreich', :team2_name => 'Albanien', :group=> GROUP_A, :round => GROUP},
      {:start_at => '19.06.2016 21:00', :place => 'Lille', :team1_name => 'Schweiz', :team2_name => 'Frankreich', :group=> GROUP_A, :round => GROUP},
      {:start_at => '19.06.2016 21:00', :place => 'Lyon', :team1_name => 'Rumänien', :team2_name => 'Albanien', :group=> GROUP_A, :round => GROUP},

      # Gruppe B
      {:start_at => '11.06.2016 18:00', :place => 'Bordeaux', :team1_name => 'Wales', :team2_name => 'Slowakei', :group=> GROUP_B, :round => GROUP},
      {:start_at => '11.06.2016 21:00', :place => 'Marseille', :team1_name => 'England', :team2_name => 'Russland', :group=> GROUP_B, :round => GROUP},
      {:start_at => '15.06.2016 15:00', :place => 'Lille', :team1_name => 'Russland', :team2_name => 'Slowakei', :group=> GROUP_B, :round => GROUP},
      {:start_at => '16.06.2016 15:00', :place => 'Lens', :team1_name => 'England', :team2_name => 'Wales', :group=> GROUP_B, :round => GROUP},
      {:start_at => '20.06.2016 21:00', :place => 'Saint-Étienne', :team1_name => 'Slowakei', :team2_name => 'England', :group=> GROUP_B, :round => GROUP},
      {:start_at => '20.06.2016 21:00', :place => 'Toulouse', :team1_name => 'Russland', :team2_name => 'Wales', :group=> GROUP_B, :round => GROUP},

      # Gruppe C
      {:start_at => '12.06.2016 18:00', :place => 'Nizza', :team1_name => 'Polen', :team2_name => 'Nordirland', :group=> GROUP_C, :round => GROUP},
      {:start_at => '12.06.2016 21:00', :place => 'Lille', :team1_name => 'Deutschland', :team2_name => 'Ukraine', :group=> GROUP_C, :round => GROUP},
      {:start_at => '16.06.2016 18:00', :place => 'Lyon', :team1_name => 'Ukraine', :team2_name => 'Nordirland', :group=> GROUP_C, :round => GROUP},
      {:start_at => '16.06.2016 21:00', :place => 'Saint-Denis', :team1_name => 'Deutschland', :team2_name => 'Polen', :group=> GROUP_C, :round => GROUP},
      {:start_at => '21.06.2016 18:00', :place => 'Marseille', :team1_name => 'Ukraine', :team2_name => 'Polen', :group=> GROUP_C, :round => GROUP},
      {:start_at => '21.06.2016 18:00', :place => 'Paris', :team1_name => 'Nordirland', :team2_name => 'Deutschland', :group=> GROUP_C, :round => GROUP},

      # Gruppe D
      {:start_at => '12.06.2016 15:00', :place => 'Paris', :team1_name => 'Türkei', :team2_name => 'Kroatien', :group=> GROUP_D, :round => GROUP},
      {:start_at => '13.06.2016 15:00', :place => 'Toulouse', :team1_name => 'Spanien', :team2_name => 'Tschechien', :group=> GROUP_D, :round => GROUP},
      {:start_at => '17.06.2016 18:00', :place => 'Saint-Étienne', :team1_name => 'Tschechien', :team2_name => 'Kroatien', :group=> GROUP_D, :round => GROUP},
      {:start_at => '17.06.2016 21:00', :place => 'Nizza', :team1_name => 'Spanien', :team2_name => 'Türkei', :group=> GROUP_D, :round => GROUP},
      {:start_at => '21.06.2016 21:00', :place => 'Bordeaux', :team1_name => 'Kroatien', :team2_name => 'Spanien', :group=> GROUP_D, :round => GROUP},
      {:start_at => '21.06.2016 21:00', :place => 'Lens', :team1_name => 'Tschechien', :team2_name => 'Türkei', :group=> GROUP_D, :round => GROUP},

      # Gruppe E
      {:start_at => '13.06.2016 18:00', :place => 'Saint-Denis', :team1_name => 'Irland', :team2_name => 'Schweden', :group=> GROUP_E, :round => GROUP},
      {:start_at => '13.06.2016 21:00', :place => 'Lyon', :team1_name => 'Belgien', :team2_name => 'Italien', :group=> GROUP_E, :round => GROUP},
      {:start_at => '17.06.2016 15:00', :place => 'Toulouse', :team1_name => 'Italien', :team2_name => 'Schweden', :group=> GROUP_E, :round => GROUP},
      {:start_at => '18.06.2016 15:00', :place => 'Bordeaux', :team1_name => 'Belgien', :team2_name => 'Irland', :group=> GROUP_E, :round => GROUP},
      {:start_at => '22.06.2016 21:00', :place => 'Lille', :team1_name => 'Italien', :team2_name => 'Irland', :group=> GROUP_E, :round => GROUP},
      {:start_at => '22.06.2016 21:00', :place => 'Nizza', :team1_name => 'Schweden', :team2_name => 'Belgien', :group=> GROUP_E, :round => GROUP},

      # Gruppe F
      {:start_at => '14.06.2016 18:00', :place => 'Bordeaux', :team1_name => 'Österreich', :team2_name => 'Ungarn', :group=> GROUP_F, :round => GROUP},
      {:start_at => '24.06.2016 21:00', :place => 'Saint-Étienne', :team1_name => 'Portugal', :team2_name => 'Island', :group=> GROUP_F, :round => GROUP},
      {:start_at => '18.06.2016 18:00', :place => 'Marseille', :team1_name => 'Island', :team2_name => 'Ungarn', :group=> GROUP_F, :round => GROUP},
      {:start_at => '18.06.2016 21:00', :place => 'Paris', :team1_name => 'Portugal', :team2_name => 'Österreich', :group=> GROUP_F, :round => GROUP},
      {:start_at => '22.06.2016 18:00', :place => 'Lyon', :team1_name => 'Ungarn', :team2_name => 'Portugal', :group=> GROUP_F, :round => GROUP},
      {:start_at => '22.06.2016 18:00', :place => 'Saint-Denis', :team1_name => 'Island', :team2_name => 'Österreich', :group=> GROUP_F, :round => GROUP},

      # Achtelfinale
      {:start_at => '25.06.2016 15:00', :place => 'Saint-Étienne', :team1_placeholder_name => '2. Gruppe A', :team2_placeholder_name => '2. Gruppe C', :group=> nil, :round => ROUND_OF_16},
      {:start_at => '25.06.2016 18:00', :place => 'Paris', :team1_placeholder_name => '1. Gruppe B', :team2_placeholder_name => '3. Gruppe A/C/D', :group=> nil, :round => ROUND_OF_16},
      {:start_at => '25.06.2016 21:00', :place => 'Lens', :team1_placeholder_name => '1. Gruppe D', :team2_placeholder_name => '3. Gruppe B/E/F', :group=> nil, :round => ROUND_OF_16},
      {:start_at => '26.06.2016 15:00', :place => 'Lyon', :team1_placeholder_name => '1. Gruppe A', :team2_placeholder_name => '3. Gruppe C/D/E', :group=> nil, :round => ROUND_OF_16},
      {:start_at => '26.06.2016 18:00', :place => 'Lille', :team1_placeholder_name => '1. Gruppe C', :team2_placeholder_name => '3. Gruppe A/B/F', :group=> nil, :round => ROUND_OF_16},
      {:start_at => '26.06.2016 21:00', :place => 'Toulouse', :team1_placeholder_name => '1. Gruppe F', :team2_placeholder_name => '2. Gruppe E', :group=> nil, :round => ROUND_OF_16},
      {:start_at => '27.06.2016 18:00', :place => 'Saint-Denis', :team1_placeholder_name => '1. Gruppe E', :team2_placeholder_name => '2. Gruppe D', :group=> nil, :round => ROUND_OF_16},
      {:start_at => '27.06.2016 21:00', :place => 'Nizza', :team1_placeholder_name => '2. Gruppe B', :team2_placeholder_name => '2. Gruppe F', :group=> nil, :round => ROUND_OF_16},

      # Viertelfinale
      {:start_at => '30.06.2016 21:00', :place => 'Marseille', :team1_placeholder_name => '1. Achtelfinale 1', :team2_placeholder_name => '1. Achtelfinale 3', :group=> nil, :round => QUARTERFINAL},
      {:start_at => '01.07.2016 21:00', :place => 'Lille', :team1_placeholder_name => '1. Achtelfinale 2', :team2_placeholder_name => '1. Achtelfinale 6', :group=> nil, :round => QUARTERFINAL},
      {:start_at => '02.07.2016 21:00', :place => 'Bordeaux', :team1_placeholder_name => '1. Achtelfinale 5', :team2_placeholder_name => '1. Achtelfinale 7', :group=> nil, :round => QUARTERFINAL},
      {:start_at => '03.07.2016 21:00', :place => 'Saint-Denis', :team1_placeholder_name => '1. Achtelfinale 4', :team2_placeholder_name => '1. Achtelfinale 8', :group=> nil, :round => QUARTERFINAL},

      # Halbfinale
      {:start_at => '06.07.2016 21:00', :place => 'Lyon', :team1_placeholder_name => '. Viertelfinale 1', :team2_placeholder_name => '. Viertelfinale 2', :group=> nil, :round => SEMIFINAL},
      {:start_at => '07.07.2016 21:00', :place => 'Marseille', :team1_placeholder_name => '. Viertelfinale 3', :team2_placeholder_name => '. Viertelfinale 4', :group=> nil, :round => SEMIFINAL},

      # Finale
      {:start_at => '10.07.2016 21:00', :place => 'Saint-Denis', :team1_placeholder_name => '1. Halbfinale 1', :team2_placeholder_name => '1. Halbfinale 2', :group=> nil, :round => FINAL},
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
      team_ids = team_ids.merge({:team1_id => team1.id})
    end
    if team2_name.present?
      team2 = Team.where(name: team2_name).first_or_create
      team2.update_column(:country_code, country_codes[team2_name])
      team_ids = team_ids.merge({:team2_id => team2.id})
    end

    Game.create!(data.merge(team_ids))
  end
end


def load_demo_user_and_random_tips
  100.times.each do |i|
    firstname = "test#{i+1}"
    lastname = 'user'

    # Wenn der Nutzer nicht schon existiert, wird er samt Zufallstipps angelegt
    unless User.exists?(firstname: firstname)
      # gleich als angemeldeter Nutzer anlegen - confirmed_at
      user = User.new({email: "#{firstname}@soemo.org",
                       password: 'testtest',
                       firstname: firstname, lastname: lastname})
      user.confirmed_at = Time.now.utc
      user.confirmation_sent_at = 1.hour.ago
      user.confirm!
      puts "Nutzer #{user.name} angelegt"
      if user.present?
        games = Game.all
        if games.present?
          games.each do |game|
            Tip.create!(user: user, game: game, team1_goals: get_random_goal, team2_goals: get_random_goal)
          end
        end
      end
    end
  end
end

def get_random_goal
  rand(5)
end

# setzt Zufallstore und das Spiel auf abgeschlossen
def set_random_game_goals
  games = Game.all
  if games.present?
    games.each do |game|
      game.update_attributes({:team1_goals => get_random_goal,
                              :team2_goals => get_random_goal,
                              :finished => true})
    end
  end
end

puts 'Lade seeds'

# Bei Rake-Task load_demo_data=true mitgeben
load_demo_data = ENV['load_demo_data']

# puts 'Alles loeschen...'
# Achtung nicht in production aufrufen clear_seeds

puts 'Spiele neu aufsetzen...'
# TO DO zur Sicherheit auskommentiert
#clear_games
create_team_and_game_data

if load_demo_data == 'true'
  puts ' load_demo_data !!!'
  load_demo_user_and_random_tips
  set_random_game_goals
end

puts 'fertsch!'

