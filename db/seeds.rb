# -*- encoding : utf-8 -*-

def clear_seeds
  # Alle Tabellen (inkl. N:M-Tabellen) werden geloescht
  ActiveRecord::Base.connection.tables.each do |table|
    next if ['schema_migrations', 'users'].include?(table)
    ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
  end

  # extra Löschen der Testuser
  users = User.all.select{|u| u.firstname =~ /^test[0-5]{5}$/}
  users.each do |u|
    u.destroy!
  end

end

def clear_games
  # Games Tabellen wird gelöscht
  ActiveRecord::Base.connection.execute('TRUNCATE games')
end

# Die Flagen kommen von https://github.com/lafeber/world-flags-sprite
# The countries corresponding to the codes can be found at http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
# http://de.wikipedia.org/wiki/ISO-3166-1-Kodierliste
def country_code_map
  {
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
      'Italien' => 'it',
      'Japan' => 'jp',
      'Kamerun' => 'cm',
      'Kolumbien' => 'co',
      'Kroatien' => 'hr',
      'Mexiko' => 'mx',
      'Niederlande' => 'nl',
      'Nigeria' => 'ng',
      'Portugal' => 'pt',
      'Russland' => 'ru',
      'Schweiz' => 'ch',
      'Spanien' => 'es',
      'Südkorea' => 'kr',
      'USA' => 'us',
      'Uruguay' => 'uy'
  }
end



def game_data
  [
      # Gruppe A
      {:start_at => '12.06.2014 22:00', :place => 'São Paulo', :team1_name => 'Brasilien', :team2_name => 'Kroatien', :group=> GROUP_A, :round => GROUP},
      {:start_at => '13.06.2014 18:00', :place => 'Natal', :team1_name => 'Mexiko', :team2_name => 'Kamerun', :group=> GROUP_A, :round => GROUP},
      {:start_at => '17.06.2014 21:00', :place => 'Fortaleza', :team1_name => 'Brasilien', :team2_name => 'Mexiko', :group=> GROUP_A, :round => GROUP},
      {:start_at => '19.06.2014 00:00', :place => 'Manaus', :team1_name => 'Kamerun', :team2_name => 'Kroatien', :group=> GROUP_A, :round => GROUP},
      {:start_at => '23.06.2014 22:00', :place => 'Brasília', :team1_name => 'Kamerun', :team2_name => 'Brasilien', :group=> GROUP_A, :round => GROUP},
      {:start_at => '23.06.2014 22:00', :place => 'Recife', :team1_name => 'Kroatien', :team2_name => 'Mexiko', :group=> GROUP_A, :round => GROUP},

      # Gruppe B
      {:start_at => '13.06.2014 21:00', :place => 'Salvador', :team1_name => 'Spanien', :team2_name => 'Niederlande', :group=> GROUP_B, :round => GROUP},
      {:start_at => '14.06.2014 00:00', :place => 'Cuiabá', :team1_name => 'Chile', :team2_name => 'Australien', :group=> GROUP_B, :round => GROUP},
      {:start_at => '18.06.2014 18:00', :place => 'Porto Alegre', :team1_name => 'Australien', :team2_name => 'Niederlande', :group=> GROUP_B, :round => GROUP},
      {:start_at => '18.06.2014 21:00', :place => 'Rio de Janeiro', :team1_name => 'Spanien', :team2_name => 'Chile', :group=> GROUP_B, :round => GROUP},
      {:start_at => '23.06.2014 18:00', :place => 'Curitiba', :team1_name => 'Australien', :team2_name => 'Spanien', :group=> GROUP_B, :round => GROUP},
      {:start_at => '23.06.2014 18:00', :place => 'São Paulo', :team1_name => 'Niederlande', :team2_name => 'Chile', :group=> GROUP_B, :round => GROUP},

      #Gruppe C
      {:start_at => '14.06.2014 18:00', :place => 'Belo Horizonte', :team1_name => 'Kolumbien', :team2_name => 'Griechenland', :group=> GROUP_C, :round => GROUP},
      {:start_at => '15.06.2014 03:00', :place => 'Recife', :team1_name => 'Elfenbeinküste', :team2_name => 'Japan', :group=> GROUP_C, :round => GROUP},
      {:start_at => '19.06.2014 18:00', :place => 'Brasília', :team1_name => 'Kolumbien', :team2_name => 'Elfenbeinküste', :group=> GROUP_C, :round => GROUP},
      {:start_at => '20.06.2014 00:00', :place => 'Natal', :team1_name => 'Japan', :team2_name => 'Griechenland', :group=> GROUP_C, :round => GROUP},
      {:start_at => '24.06.2014 22:00', :place => 'Cuiabá', :team1_name => 'Japan', :team2_name => 'Kolumbien', :group=> GROUP_C, :round => GROUP},
      {:start_at => '24.06.2014 22:00', :place => 'Fortaleza', :team1_name => 'Griechenland', :team2_name => 'Elfenbeinküste', :group=> GROUP_C, :round => GROUP},

      # Gruppe D
      {:start_at => '14.06.2014 21:00', :place => 'Fortaleza', :team1_name => 'Uruguay', :team2_name => 'Costa Rica', :group=> GROUP_D, :round => GROUP},
      {:start_at => '15.06.2014 00:00', :place => 'Manaus', :team1_name => 'England', :team2_name => 'Italien', :group=> GROUP_D, :round => GROUP},
      {:start_at => '19.06.2014 21:00', :place => 'São Paulo', :team1_name => 'Uruguay', :team2_name => 'England', :group=> GROUP_D, :round => GROUP},
      {:start_at => '20.06.2014 18:00', :place => 'Recife', :team1_name => 'Italien', :team2_name => 'Costa Rica', :group=> GROUP_D, :round => GROUP},
      {:start_at => '24.06.2014 18:00', :place => 'Natal', :team1_name => 'Costa Rica', :team2_name => 'England', :group=> GROUP_D, :round => GROUP},
      {:start_at => '24.06.2014 18:00', :place => 'Belo Horizonte', :team1_name => 'Italien', :team2_name => 'Uruguay', :group=> GROUP_D, :round => GROUP},

      # Gruppe E
      {:start_at => '15.06.2014 18:00', :place => 'Brasília', :team1_name => 'Schweiz', :team2_name => 'Ecuador', :group=> GROUP_E, :round => GROUP},
      {:start_at => '15.06.2014 21:00', :place => 'Porto Alegre', :team1_name => 'Frankreich', :team2_name => 'Honduras', :group=> GROUP_E, :round => GROUP},
      {:start_at => '20.06.2014 21:00', :place => 'Salvador', :team1_name => 'Schweiz', :team2_name => 'Frankreich', :group=> GROUP_E, :round => GROUP},
      {:start_at => '21.06.2014 00:00', :place => 'Curitiba', :team1_name => 'Honduras', :team2_name => 'Ecuador', :group=> GROUP_E, :round => GROUP},
      {:start_at => '25.06.2014 22:00', :place => 'Manaus', :team1_name => 'Honduras', :team2_name => 'Schweiz', :group=> GROUP_E, :round => GROUP},
      {:start_at => '25.06.2014 22:00', :place => 'Rio de Janeiro', :team1_name => 'Ecuador', :team2_name => 'Frankreich', :group=> GROUP_E, :round => GROUP},

      # Gruppe F
      {:start_at => '16.06.2014 00:00', :place => 'Rio de Janeiro', :team1_name => 'Argentinien', :team2_name => 'Bosnien-Herzegowina', :group=> GROUP_F, :round => GROUP},
      {:start_at => '16.06.2014 21:00', :place => 'Curitiba', :team1_name => 'Iran', :team2_name => 'Nigeria', :group=> GROUP_F, :round => GROUP},
      {:start_at => '21.06.2014 18:00', :place => 'Belo Horizonte', :team1_name => 'Argentinien', :team2_name => 'Iran', :group=> GROUP_F, :round => GROUP},
      {:start_at => '22.06.2014 00:00', :place => 'Cuiabá', :team1_name => 'Nigeria', :team2_name => 'Bosnien-Herzegowina', :group=> GROUP_F, :round => GROUP},
      {:start_at => '25.06.2014 18:00', :place => 'Porto Alegre', :team1_name => 'Nigeria', :team2_name => 'Argentinien', :group=> GROUP_F, :round => GROUP},
      {:start_at => '25.06.2014 18:00', :place => 'Salvador', :team1_name => 'Bosnien-Herzegowina', :team2_name => 'Iran', :group=> GROUP_F, :round => GROUP},

      # Gruppe G
      {:start_at => '16.06.2014 18:00', :place => 'Salvador', :team1_name => 'Deutschland', :team2_name => 'Portugal', :group=> GROUP_G, :round => GROUP},
      {:start_at => '17.06.2014 00:00', :place => 'Natal', :team1_name => 'Ghana', :team2_name => 'USA', :group=> GROUP_G, :round => GROUP},
      {:start_at => '21.06.2014 21:00', :place => 'Fortaleza', :team1_name => 'Deutschland', :team2_name => 'Ghana', :group=> GROUP_G, :round => GROUP},
      {:start_at => '23.06.2014 00:00', :place => 'Manaus', :team1_name => 'USA', :team2_name => 'Portugal', :group=> GROUP_G, :round => GROUP},
      {:start_at => '26.06.2014 18:00', :place => 'Brasília', :team1_name => 'Portugal', :team2_name => 'Ghana', :group=> GROUP_G, :round => GROUP},
      {:start_at => '26.06.2014 18:00', :place => 'Recife', :team1_name => 'USA', :team2_name => 'Deutschland', :group=> GROUP_G, :round => GROUP},

      # Gruppe H
      {:start_at => '17.06.2014 18:00', :place => 'Belo Horizonte', :team1_name => 'Belgien', :team2_name => 'Algerien', :group=> GROUP_H, :round => GROUP},
      {:start_at => '18.06.2014 00:00', :place => 'Cuiabá', :team1_name => 'Russland', :team2_name => 'Südkorea', :group=> GROUP_H, :round => GROUP},
      {:start_at => '22.06.2014 18:00', :place => 'Porto Alegre', :team1_name => 'Belgien', :team2_name => 'Russland', :group=> GROUP_H, :round => GROUP},
      {:start_at => '22.06.2014 21:00', :place => 'Rio de Janeiro', :team1_name => 'Südkorea', :team2_name => 'Algerien', :group=> GROUP_H, :round => GROUP},
      {:start_at => '26.06.2014 22:00', :place => 'São Paulo', :team1_name => 'Algerien', :team2_name => 'Russland', :group=> GROUP_H, :round => GROUP},
      {:start_at => '26.06.2014 22:00', :place => 'Curitiba', :team1_name => 'Südkorea', :team2_name => 'Belgien', :group=> GROUP_H, :round => GROUP},

      # Achtelfinale
      {:start_at => '28.06.2014 18:00', :place => 'Belo Horizonte', :team1_placeholder_name => 'Sieger Gruppe A', :team2_placeholder_name => 'Zweiter Gruppe B', :group=> nil, :round => ROUND_OF_16},
      {:start_at => '28.06.2014 22:00', :place => 'Rio de Janeiro', :team1_placeholder_name => 'Sieger Gruppe C', :team2_placeholder_name => 'Zweiter Gruppe D', :group=> nil, :round => ROUND_OF_16},
      {:start_at => '29.06.2014 18:00', :place => 'Fortaleza', :team1_placeholder_name => 'Sieger Gruppe B', :team2_placeholder_name => 'Zweiter Gruppe A', :group=> nil, :round => ROUND_OF_16},
      {:start_at => '29.06.2014 22:00', :place => 'Recife', :team1_placeholder_name => 'Sieger Gruppe D', :team2_placeholder_name => 'Zweiter Gruppe C', :group=> nil, :round => ROUND_OF_16},
      {:start_at => '30.06.2014 18:00', :place => 'Brasília', :team1_placeholder_name => 'Sieger Gruppe E', :team2_placeholder_name => 'Zweiter Gruppe F', :group=> nil, :round => ROUND_OF_16},
      {:start_at => '30.06.2014 22:00', :place => 'Porto Alegre', :team1_placeholder_name => 'Sieger Gruppe G', :team2_placeholder_name => 'Zweiter Gruppe H', :group=> nil, :round => ROUND_OF_16},
      {:start_at => '01.07.2014 18:00', :place => 'São Paulo', :team1_placeholder_name => 'Sieger Gruppe F', :team2_placeholder_name => 'Zweiter Gruppe E', :group=> nil, :round => ROUND_OF_16},
      {:start_at => '01.07.2014 22:00', :place => 'Salvador', :team1_placeholder_name => 'Sieger Gruppe H', :team2_placeholder_name => 'Zweiter Gruppe G', :group=> nil, :round => ROUND_OF_16},

      # Viertelfinale
      {:start_at => '04.07.2014 18:00', :place => 'Rio de Janeiro', :team1_placeholder_name => 'Sieger AF 5', :team2_placeholder_name => 'Sieger AF 6', :group=> nil, :round => QUARTERFINAL},
      {:start_at => '04.07.2014 22:00', :place => 'Fortaleza', :team1_placeholder_name => 'Sieger AF 1', :team2_placeholder_name => 'Sieger AF 2', :group=> nil, :round => QUARTERFINAL},
      {:start_at => '05.07.2014 18:00', :place => 'Brasília', :team1_placeholder_name => 'Sieger AF 7', :team2_placeholder_name => 'Sieger AF 8', :group=> nil, :round => QUARTERFINAL},
      {:start_at => '05.07.2014 22:00', :place => 'Salvador', :team1_placeholder_name => 'Sieger AF 3', :team2_placeholder_name => 'Sieger AF 4', :group=> nil, :round => QUARTERFINAL},

      # Halbfinale
      {:start_at => '08.07.2014 22:00', :place => 'Belo Horizonte', :team1_placeholder_name => 'Sieger VF 1', :team2_placeholder_name => 'Sieger VF 2', :group=> nil, :round => SEMIFINAL},
      {:start_at => '09.07.2014 22:00', :place => 'São Paulo', :team1_placeholder_name => 'Sieger VF 4', :team2_placeholder_name => 'Sieger VF 3', :group=> nil, :round => SEMIFINAL},

      # Spiel um Platz 3
      {:start_at => '12.07.2014 22:00', :place => 'Brasília', :team1_placeholder_name => 'Verlierer HF 1', :team2_placeholder_name => 'Verlierer HF 2', :group=> nil, :round => PLACE_3},

      # Finale
      {:start_at => '13.07.2014 21:00', :place => 'Rio de Janeiro', :team1_placeholder_name => 'Sieger HF 1', :team2_placeholder_name => 'Sieger HF 2', :group=> nil, :round => FINAL},
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
# TODO soeren 21.05.12 zur Sicherheit auskommentiert
#clear_games
#create_team_and_game_data

if load_demo_data == 'true'
  puts ' load_demo_data !!!'
  load_demo_user_and_random_tips
  set_random_game_goals
end

puts 'fertsch!'

