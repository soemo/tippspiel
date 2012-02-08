
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


def game_data
  [
    {:start_at => "08.06.2012 18:00", :place => "Warschau", :team1_name => "Polen", :team2_name => "A2", :group=> "A", :round => Game::GROUP},
    {:start_at => "08.06.2012 20:45", :place => "Wroclaw", :team1_name => "A3", :team2_name => "A4", :group=> "A", :round => Game::GROUP},
    {:start_at => "12.06.2012 18:00", :place => "Wroclaw", :team1_name => "A2", :team2_name => "A4", :group=> "A", :round => Game::GROUP},
    {:start_at => "12.06.2012 20:45", :place => "Warschau", :team1_name => "Polen", :team2_name => "A3", :group=> "A", :round => Game::GROUP},
    {:start_at => "16.06.2012 20:45", :place => "Wroclaw", :team1_name => "A4", :team2_name => "Polen", :group=> "A", :round => Game::GROUP},
    {:start_at => "16.06.2012 20:45", :place => "Warschau", :team1_name => "A2", :team2_name => "A3", :group=> "A", :round => Game::GROUP},

    {:start_at => "09.06.2012 18:00", :place => "Charkiw", :team1_name => "B1", :team2_name => "B2", :group=> "B", :round => Game::GROUP},
    {:start_at => "09.06.2012 20:45", :place => "Lwiw", :team1_name => "B3", :team2_name => "B4", :group=> "B", :round => Game::GROUP},
    {:start_at => "13.06.2012 18:00", :place => "Lwiw", :team1_name => "B2", :team2_name => "B4", :group=> "B", :round => Game::GROUP},
    {:start_at => "13.06.2012 20:45", :place => "Charkiw", :team1_name => "B1", :team2_name => "B3", :group=> "B", :round => Game::GROUP},
    {:start_at => "17.06.2012 20:45", :place => "Charkiw", :team1_name => "B4", :team2_name => "B1", :group=> "B", :round => Game::GROUP},
    {:start_at => "17.06.2012 20:45", :place => "Lwiw", :team1_name => "B2", :team2_name => "B3", :group=> "B", :round => Game::GROUP},

    {:start_at => "10.06.2012 18:00", :place => "Gdansk", :team1_name => "C1", :team2_name => "C2", :group=> "C", :round => Game::GROUP},
    {:start_at => "10.06.2012 20:45", :place => "Poznan", :team1_name => "C3", :team2_name => "C4", :group=> "C", :round => Game::GROUP},
    {:start_at => "14.06.2012 18:00", :place => "Poznan", :team1_name => "C2", :team2_name => "C4", :group=> "C", :round => Game::GROUP},
    {:start_at => "14.06.2012 20:45", :place => "Gdansk", :team1_name => "C1", :team2_name => "C3", :group=> "C", :round => Game::GROUP},
    {:start_at => "18.06.2012 20:45", :place => "Gdansk", :team1_name => "C4", :team2_name => "C1", :group=> "C", :round => Game::GROUP},
    {:start_at => "18.06.2012 20:45", :place => "Poznan", :team1_name => "C2", :team2_name => "C3", :group=> "C", :round => Game::GROUP},

    {:start_at => "11.06.2012 18:00", :place => "Donezk", :team1_name => "D3", :team2_name => "D4", :group=> "D", :round => Game::GROUP},
    {:start_at => "11.06.2012 20:45", :place => "Kiew", :team1_name => "Ukraine", :team2_name => "D2", :group=> "D", :round => Game::GROUP},
    {:start_at => "15.06.2012 18:00", :place => "Kiew", :team1_name => "D2", :team2_name => "D4", :group=> "D", :round => Game::GROUP},
    {:start_at => "15.06.2012 20:45", :place => "Donezk", :team1_name => "Ukraine", :team2_name => "D3", :group=> "D", :round => Game::GROUP},
    {:start_at => "19.06.2012 20:45", :place => "Donezk", :team1_name => "D4", :team2_name => "Ukraine", :group=> "D", :round => Game::GROUP},
    {:start_at => "19.06.2012 20:45", :place => "Kiew", :team1_name => "D2", :team2_name => "D3", :group=> "D", :round => Game::GROUP},

    {:start_at => "21.06.2012 20:45", :place => "Warschau", :team1_placeholder_name => "Sieger Gruppe A", :team2_placeholder_name => "Zweiter Gruppe B", :group=> nil, :round => Game::QUARTERFINAL},
    {:start_at => "22.06.2012 20:45", :place => "Gdansk", :team1_placeholder_name => "Sieger Gruppe B", :team2_placeholder_name => "Zweiter Gruppe A", :group=> nil, :round => Game::QUARTERFINAL},
    {:start_at => "23.06.2012 20:45", :place => "Donezk", :team1_placeholder_name => "Sieger Gruppe C", :team2_placeholder_name => "Zweiter Gruppe D", :group=> nil, :round => Game::QUARTERFINAL},
    {:start_at => "24.06.2012 20:45", :place => "Kiew", :team1_placeholder_name => "Sieger Gruppe D", :team2_placeholder_name => "Zweiter Gruppe C", :group=> nil, :round => Game::QUARTERFINAL},

    {:start_at => "27.06.2012 20:45", :place => "Donezk", :team1_placeholder_name => "Sieger Viertelfinale Warschau", :team2_placeholder_name => "Sieger Viertelfinale Donezk", :group=> nil, :round => Game::SEMIFINAL},
    {:start_at => "28.06.2012 20:45", :place => "Warschau", :team1_placeholder_name => "Sieger Viertelfinale Gdansk", :team2_placeholder_name => "Sieger Viertelfinale Kiew", :group=> nil, :round => Game::SEMIFINAL},

    {:start_at => "01.07.2012 20:45", :place => "Warschau", :team1_placeholder_name => "Sieger Halbfinale 1", :team2_placeholder_name => "Sieger Halbfinale 2", :group=> nil, :round => Game::FINAL}
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

# test und 5 Zahlen regex /^test[0-5]{5}$/
def testuser_firstname
  "test#{rand(5)}#{rand(5)}#{rand(5)}#{rand(5)}#{rand(5)}"
end

def create_testusers
  10.times do |i|
    n = i+1
    user = User.new(:firstname => testuser_firstname, :lastname => "User#{n}", :email => "testuser#{n}@soemo.de", :password => "testuser#{n}", :password_confirmation => "testuser#{n}")
    user.confirm!
  end
end

def create_tipps
  games = Game.all
  users = User.all
  users.each do |user|
    games.each do |game|
      Tipp.create!(:user => user, :game => game, :team1_tore => rand(3), :team2_tore => rand(3))
    end
  end

end


puts "Lade seeds"

puts "Alles loeschen..."
clear_seeds

puts "Neue Daten aufsetzen..."
## FIXME soeren 08.02.12 create_game_data
## FIXME soeren 08.02.12 create_testusers
## FIXME soeren 08.02.12 create_tipps
# TODO soeren 22.11.11 create_polls
# TODO soeren 22.11.11 create_notice
# TODO soeren 22.11.11 create_statistics
puts "fertsch!"

