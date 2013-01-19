# -*- encoding : utf-8 -*-

def clear_seeds
  # Alle Tabellen (inkl. N:M-Tabellen) werden geloescht
  ActiveRecord::Base.connection.tables.each do |table|
    next if ["schema_migrations", "users", "admin_users"].include?(table)
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
  ActiveRecord::Base.connection.execute("TRUNCATE games")
end


def game_data
  [
    {:start_at => "08.06.2012 18:00", :place => "Warschau", :team1_name => "Polen", :team2_name => "Griechenland", :group=> Game::GROUP_A, :round => Game::GROUP},
    {:start_at => "08.06.2012 20:45", :place => "Breslau", :team1_name => "Russland", :team2_name => "Tschechien", :group=> Game::GROUP_A, :round => Game::GROUP},
    {:start_at => "12.06.2012 18:00", :place => "Breslau", :team1_name => "Griechenland", :team2_name => "Tschechien", :group=> Game::GROUP_A, :round => Game::GROUP},
    {:start_at => "12.06.2012 20:45", :place => "Warschau", :team1_name => "Polen", :team2_name => "Russland", :group=> Game::GROUP_A, :round => Game::GROUP},
    {:start_at => "16.06.2012 20:45", :place => "Breslau", :team1_name => "Tschechien", :team2_name => "Polen", :group=> Game::GROUP_A, :round => Game::GROUP},
    {:start_at => "16.06.2012 20:45", :place => "Warschau", :team1_name => "Griechenland", :team2_name => "Russland", :group=> Game::GROUP_A, :round => Game::GROUP},

    {:start_at => "09.06.2012 18:00", :place => "Charkow", :team1_name => "Niederlande", :team2_name => "Dänemark", :group=> Game::GROUP_B, :round => Game::GROUP},
    {:start_at => "09.06.2012 20:45", :place => "Lwiw", :team1_name => "Deutschland", :team2_name => "Portugal", :group=> Game::GROUP_B, :round => Game::GROUP},
    {:start_at => "13.06.2012 18:00", :place => "Lwiw", :team1_name => "Dänemark", :team2_name => "Portugal", :group=> Game::GROUP_B, :round => Game::GROUP},
    {:start_at => "13.06.2012 20:45", :place => "Charkow", :team1_name => "Niederlande", :team2_name => "Deutschland", :group=> Game::GROUP_B, :round => Game::GROUP},
    {:start_at => "17.06.2012 20:45", :place => "Charkow", :team1_name => "Portugal", :team2_name => "Niederlande", :group=> Game::GROUP_B, :round => Game::GROUP},
    {:start_at => "17.06.2012 20:45", :place => "Lwiw", :team1_name => "Dänemark", :team2_name => "Deutschland", :group=> Game::GROUP_B, :round => Game::GROUP},

    {:start_at => "10.06.2012 18:00", :place => "Danzig", :team1_name => "Spanien", :team2_name => "Italien", :group=> Game::GROUP_C, :round => Game::GROUP},
    {:start_at => "10.06.2012 20:45", :place => "Posen", :team1_name => "Irland", :team2_name => "Kroatien", :group=> Game::GROUP_C, :round => Game::GROUP},
    {:start_at => "14.06.2012 18:00", :place => "Posen", :team1_name => "Italien", :team2_name => "Kroatien", :group=> Game::GROUP_C, :round => Game::GROUP},
    {:start_at => "14.06.2012 20:45", :place => "Danzig", :team1_name => "Spanien", :team2_name => "Irland", :group=> Game::GROUP_C, :round => Game::GROUP},
    {:start_at => "18.06.2012 20:45", :place => "Danzig", :team1_name => "Kroatien", :team2_name => "Spanien", :group=> Game::GROUP_C, :round => Game::GROUP},
    {:start_at => "18.06.2012 20:45", :place => "Posen", :team1_name => "Italien", :team2_name => "Irland", :group=> Game::GROUP_C, :round => Game::GROUP},

    {:start_at => "11.06.2012 18:00", :place => "Donezk", :team1_name => "Frankreich", :team2_name => "England", :group=> Game::GROUP_D, :round => Game::GROUP},
    {:start_at => "11.06.2012 20:45", :place => "Kiew", :team1_name => "Ukraine", :team2_name => "Schweden", :group=> Game::GROUP_D, :round => Game::GROUP},
    {:start_at => "15.06.2012 18:00", :place => "Donezk", :team1_name => "Ukraine", :team2_name => "Frankreich", :group=> Game::GROUP_D, :round => Game::GROUP},
    {:start_at => "15.06.2012 20:45", :place => "Kiew", :team1_name => "Schweden", :team2_name => "England", :group=> Game::GROUP_D, :round => Game::GROUP},
    {:start_at => "19.06.2012 20:45", :place => "Donezk", :team1_name => "England", :team2_name => "Ukraine", :group=> Game::GROUP_D, :round => Game::GROUP},
    {:start_at => "19.06.2012 20:45", :place => "Kiew", :team1_name => "Schweden", :team2_name => "Frankreich", :group=> Game::GROUP_D, :round => Game::GROUP},

    {:start_at => "21.06.2012 20:45", :place => "Warschau", :team1_placeholder_name => "Sieger Gruppe A", :team2_placeholder_name => "Zweiter Gruppe B", :group=> nil, :round => Game::QUARTERFINAL},
    {:start_at => "22.06.2012 20:45", :place => "Danzig", :team1_placeholder_name => "Sieger Gruppe B", :team2_placeholder_name => "Zweiter Gruppe A", :group=> nil, :round => Game::QUARTERFINAL},
    {:start_at => "23.06.2012 20:45", :place => "Donezk", :team1_placeholder_name => "Sieger Gruppe C", :team2_placeholder_name => "Zweiter Gruppe D", :group=> nil, :round => Game::QUARTERFINAL},
    {:start_at => "24.06.2012 20:45", :place => "Kiew", :team1_placeholder_name => "Sieger Gruppe D", :team2_placeholder_name => "Zweiter Gruppe C", :group=> nil, :round => Game::QUARTERFINAL},

    {:start_at => "27.06.2012 20:45", :place => "Donezk", :team1_placeholder_name => "Sieger Viertelfinale Warschau", :team2_placeholder_name => "Sieger Viertelfinale Donezk", :group=> nil, :round => Game::SEMIFINAL},
    {:start_at => "28.06.2012 20:45", :place => "Warschau", :team1_placeholder_name => "Sieger Viertelfinale Danzig", :team2_placeholder_name => "Sieger Viertelfinale Kiew", :group=> nil, :round => Game::SEMIFINAL},

    {:start_at => "01.07.2012 20:45", :place => "Kiew", :team1_placeholder_name => "Sieger Halbfinale 1", :team2_placeholder_name => "Sieger Halbfinale 2", :group=> nil, :round => Game::FINAL}
  ]
end

def create_game_data
  game_data.each do |data|
    team1_name = data[:team1_name].present? ? data.delete(:team1_name) : nil
    team2_name = data[:team2_name].present? ? data.delete(:team2_name) : nil
    team_ids = {}
    if team1_name.present?
      team1 = Team.find_or_create_by_name(team1_name)
      team_ids = team_ids.merge({:team1_id => team1.id})
    end
    if team2_name.present?
      team2 = Team.find_or_create_by_name(team2_name)
      team_ids = team_ids.merge({:team2_id => team2.id})
    end

    game = Game.create!(data.merge(team_ids))
  end

end

puts "Lade seeds"

# puts "Alles loeschen..."
# Achtung nicht in production aufrufen clear_seeds

puts "Spiele neu aufsetzen..."
# TODO soeren 21.05.12 zur Sicherheit auskommentiert
#clear_games
#create_game_data

puts "fertsch!"

