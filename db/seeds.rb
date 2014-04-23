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
      {:start_at => '12.06.2014 22:00', :api_match_id => 1417819, :place => 'São Paulo', :team1_name => 'Brasilien', :team2_name => 'Kroatien', :group=> Game::GROUP_A, :round => Game::GROUP},
      {:start_at => '13.06.2014 18:00', :api_match_id => 1417820, :place => 'Natal', :team1_name => 'Mexiko', :team2_name => 'Kamerun', :group=> Game::GROUP_A, :round => Game::GROUP},
      {:start_at => '17.06.2014 21:00', :api_match_id => 1417821, :place => 'Fortaleza', :team1_name => 'Brasilien', :team2_name => 'Mexiko', :group=> Game::GROUP_A, :round => Game::GROUP},
      {:start_at => '19.06.2014 00:00', :api_match_id => 1417822, :place => 'Manaus', :team1_name => 'Kamerun', :team2_name => 'Kroatien', :group=> Game::GROUP_A, :round => Game::GROUP},
      {:start_at => '23.06.2014 22:00', :api_match_id => 1417823, :place => 'Brasília', :team1_name => 'Kamerun', :team2_name => 'Brasilien', :group=> Game::GROUP_A, :round => Game::GROUP},
      {:start_at => '23.06.2014 22:00', :api_match_id => 1417824, :place => 'Recife', :team1_name => 'Kroatien', :team2_name => 'Mexiko', :group=> Game::GROUP_A, :round => Game::GROUP},

      # Gruppe B
      {:start_at => '13.06.2014 21:00', :api_match_id => 1417825, :place => 'Salvador', :team1_name => 'Spanien', :team2_name => 'Niederlande', :group=> Game::GROUP_B, :round => Game::GROUP},
      {:start_at => '14.06.2014 00:00', :api_match_id => 1417826, :place => 'Cuiabá', :team1_name => 'Chile', :team2_name => 'Australien', :group=> Game::GROUP_B, :round => Game::GROUP},
      {:start_at => '18.06.2014 18:00', :api_match_id => 1417828, :place => 'Porto Alegre', :team1_name => 'Australien', :team2_name => 'Niederlande', :group=> Game::GROUP_B, :round => Game::GROUP},
      {:start_at => '18.06.2014 21:00', :api_match_id => 1417827, :place => 'Rio de Janeiro', :team1_name => 'Spanien', :team2_name => 'Chile', :group=> Game::GROUP_B, :round => Game::GROUP},
      {:start_at => '23.06.2014 18:00', :api_match_id => 1417829, :place => 'Curitiba', :team1_name => 'Australien', :team2_name => 'Spanien', :group=> Game::GROUP_B, :round => Game::GROUP},
      {:start_at => '23.06.2014 18:00', :api_match_id => 1417830, :place => 'São Paulo', :team1_name => 'Niederlande', :team2_name => 'Chile', :group=> Game::GROUP_B, :round => Game::GROUP},

      #Gruppe C
      {:start_at => '14.06.2014 18:00', :api_match_id => 1417831, :place => 'Belo Horizonte', :team1_name => 'Kolumbien', :team2_name => 'Griechenland', :group=> Game::GROUP_C, :round => Game::GROUP},
      {:start_at => '15.06.2014 03:00', :api_match_id => 1417832, :place => 'Recife', :team1_name => 'Elfenbeinküste', :team2_name => 'Japan', :group=> Game::GROUP_C, :round => Game::GROUP},
      {:start_at => '19.06.2014 18:00', :api_match_id => 1417833, :place => 'Brasília', :team1_name => 'Kolumbien', :team2_name => 'Elfenbeinküste', :group=> Game::GROUP_C, :round => Game::GROUP},
      {:start_at => '20.06.2014 00:00', :api_match_id => 1417834, :place => 'Natal', :team1_name => 'Japan', :team2_name => 'Griechenland', :group=> Game::GROUP_C, :round => Game::GROUP},
      {:start_at => '24.06.2014 22:00', :api_match_id => 1417835, :place => 'Cuiabá', :team1_name => 'Japan', :team2_name => 'Kolumbien', :group=> Game::GROUP_C, :round => Game::GROUP},
      {:start_at => '24.06.2014 22:00', :api_match_id => 1417836, :place => 'Fortaleza', :team1_name => 'Griechenland', :team2_name => 'Elfenbeinküste', :group=> Game::GROUP_C, :round => Game::GROUP},

      # Gruppe D
      {:start_at => '14.06.2014 21:00', :api_match_id => 1417837, :place => 'Fortaleza', :team1_name => 'Uruguay', :team2_name => 'Costa Rica', :group=> Game::GROUP_D, :round => Game::GROUP},
      {:start_at => '15.06.2014 00:00', :api_match_id => 1417838, :place => 'Manaus', :team1_name => 'England', :team2_name => 'Italien', :group=> Game::GROUP_D, :round => Game::GROUP},
      {:start_at => '19.06.2014 21:00', :api_match_id => 1417839, :place => 'São Paulo', :team1_name => 'Uruguay', :team2_name => 'England', :group=> Game::GROUP_D, :round => Game::GROUP},
      {:start_at => '20.06.2014 18:00', :api_match_id => 1417840, :place => 'Recife', :team1_name => 'Italien', :team2_name => 'Costa Rica', :group=> Game::GROUP_D, :round => Game::GROUP},
      {:start_at => '24.06.2014 18:00', :api_match_id => 1417842, :place => 'Natal', :team1_name => 'Costa Rica', :team2_name => 'England', :group=> Game::GROUP_D, :round => Game::GROUP},
      {:start_at => '24.06.2014 18:00', :api_match_id => 1417841, :place => 'Belo Horizonte', :team1_name => 'Italien', :team2_name => 'Uruguay', :group=> Game::GROUP_D, :round => Game::GROUP},

      # Gruppe E
      {:start_at => '15.06.2014 18:00', :api_match_id => 1417843, :place => 'Brasília', :team1_name => 'Schweiz', :team2_name => 'Ecuador', :group=> Game::GROUP_E, :round => Game::GROUP},
      {:start_at => '15.06.2014 21:00', :api_match_id => 1417844, :place => 'Porto Alegre', :team1_name => 'Frankreich', :team2_name => 'Honduras', :group=> Game::GROUP_E, :round => Game::GROUP},
      {:start_at => '20.06.2014 21:00', :api_match_id => 1417845, :place => 'Salvador', :team1_name => 'Schweiz', :team2_name => 'Frankreich', :group=> Game::GROUP_E, :round => Game::GROUP},
      {:start_at => '21.06.2014 00:00', :api_match_id => 1417846, :place => 'Curitiba', :team1_name => 'Honduras', :team2_name => 'Ecuador', :group=> Game::GROUP_E, :round => Game::GROUP},
      {:start_at => '25.06.2014 22:00', :api_match_id => 1417847, :place => 'Manaus', :team1_name => 'Honduras', :team2_name => 'Schweiz', :group=> Game::GROUP_E, :round => Game::GROUP},
      {:start_at => '25.06.2014 22:00', :api_match_id => 1417848, :place => 'Rio de Janeiro', :team1_name => 'Ecuador', :team2_name => 'Frankreich', :group=> Game::GROUP_E, :round => Game::GROUP},

      # Gruppe F
      {:start_at => '16.06.2014 00:00', :api_match_id => 1417849, :place => 'Rio de Janeiro', :team1_name => 'Argentinien', :team2_name => 'Bosnien-Herzegowina', :group=> Game::GROUP_F, :round => Game::GROUP},
      {:start_at => '16.06.2014 21:00', :api_match_id => 1417850, :place => 'Curitiba', :team1_name => 'Iran', :team2_name => 'Nigeria', :group=> Game::GROUP_F, :round => Game::GROUP},
      {:start_at => '21.06.2014 18:00', :api_match_id => 1417851, :place => 'Belo Horizonte', :team1_name => 'Argentinien', :team2_name => 'Iran', :group=> Game::GROUP_F, :round => Game::GROUP},
      {:start_at => '22.06.2014 00:00', :api_match_id => 1417852, :place => 'Cuiabá', :team1_name => 'Nigeria', :team2_name => 'Bosnien-Herzegowina', :group=> Game::GROUP_F, :round => Game::GROUP},
      {:start_at => '25.06.2014 18:00', :api_match_id => 1417853, :place => 'Porto Alegre', :team1_name => 'Nigeria', :team2_name => 'Argentinien', :group=> Game::GROUP_F, :round => Game::GROUP},
      {:start_at => '25.06.2014 18:00', :api_match_id => 1417854, :place => 'Salvador', :team1_name => 'Bosnien-Herzegowina', :team2_name => 'Iran', :group=> Game::GROUP_F, :round => Game::GROUP},

      # Gruppe G
      {:start_at => '16.06.2014 18:00', :api_match_id => 1417855, :place => 'Salvador', :team1_name => 'Deutschland', :team2_name => 'Portugal', :group=> Game::GROUP_G, :round => Game::GROUP},
      {:start_at => '17.06.2014 00:00', :api_match_id => 1417856, :place => 'Natal', :team1_name => 'Ghana', :team2_name => 'USA', :group=> Game::GROUP_G, :round => Game::GROUP},
      {:start_at => '21.06.2014 21:00', :api_match_id => 1417857, :place => 'Fortaleza', :team1_name => 'Deutschland', :team2_name => 'Ghana', :group=> Game::GROUP_G, :round => Game::GROUP},
      {:start_at => '23.06.2014 00:00', :api_match_id => 1417858, :place => 'Manaus', :team1_name => 'USA', :team2_name => 'Portugal', :group=> Game::GROUP_G, :round => Game::GROUP},
      {:start_at => '26.06.2014 18:00', :api_match_id => 1417859, :place => 'Brasília', :team1_name => 'Portugal', :team2_name => 'Ghana', :group=> Game::GROUP_G, :round => Game::GROUP},
      {:start_at => '26.06.2014 18:00', :api_match_id => 1417860, :place => 'Recife', :team1_name => 'USA', :team2_name => 'Deutschland', :group=> Game::GROUP_G, :round => Game::GROUP},

      # Gruppe H
      {:start_at => '17.06.2014 18:00', :api_match_id => 1417861, :place => 'Belo Horizonte', :team1_name => 'Belgien', :team2_name => 'Algerien', :group=> Game::GROUP_H, :round => Game::GROUP},
      {:start_at => '18.06.2014 00:00', :api_match_id => 1417862, :place => 'Cuiabá', :team1_name => 'Russland', :team2_name => 'Südkorea', :group=> Game::GROUP_H, :round => Game::GROUP},
      {:start_at => '22.06.2014 18:00', :api_match_id => 1417864, :place => 'Porto Alegre', :team1_name => 'Belgien', :team2_name => 'Russland', :group=> Game::GROUP_H, :round => Game::GROUP},
      {:start_at => '22.06.2014 21:00', :api_match_id => 1417863, :place => 'Rio de Janeiro', :team1_name => 'Südkorea', :team2_name => 'Algerien', :group=> Game::GROUP_H, :round => Game::GROUP},
      {:start_at => '26.06.2014 22:00', :api_match_id => 1417866, :place => 'São Paulo', :team1_name => 'Algerien', :team2_name => 'Russland', :group=> Game::GROUP_H, :round => Game::GROUP},
      {:start_at => '26.06.2014 22:00', :api_match_id => 1417865, :place => 'Curitiba', :team1_name => 'Südkorea', :team2_name => 'Belgien', :group=> Game::GROUP_H, :round => Game::GROUP},

      # Achtelfinale
      {:start_at => '28.06.2014 18:00', :api_match_id => 1417867, :place => 'Belo Horizonte', :team1_placeholder_name => 'Sieger Gruppe A', :team2_placeholder_name => 'Zweiter Gruppe B', :group=> nil, :round => Game::ROUND_OF_16},
      {:start_at => '28.06.2014 22:00', :api_match_id => 1417868, :place => 'Rio de Janeiro', :team1_placeholder_name => 'Sieger Gruppe C', :team2_placeholder_name => 'Zweiter Gruppe D', :group=> nil, :round => Game::ROUND_OF_16},
      {:start_at => '29.06.2014 18:00', :api_match_id => 1417869, :place => 'Fortaleza', :team1_placeholder_name => 'Sieger Gruppe B', :team2_placeholder_name => 'Zweiter Gruppe A', :group=> nil, :round => Game::ROUND_OF_16},
      {:start_at => '29.06.2014 22:00', :api_match_id => 1417870, :place => 'Recife', :team1_placeholder_name => 'Sieger Gruppe D', :team2_placeholder_name => 'Zweiter Gruppe C', :group=> nil, :round => Game::ROUND_OF_16},
      {:start_at => '30.06.2014 18:00', :api_match_id => 1417871, :place => 'Brasília', :team1_placeholder_name => 'Sieger Gruppe E', :team2_placeholder_name => 'Zweiter Gruppe F', :group=> nil, :round => Game::ROUND_OF_16},
      {:start_at => '30.06.2014 22:00', :api_match_id => 1417872, :place => 'Porto Alegre', :team1_placeholder_name => 'Sieger Gruppe G', :team2_placeholder_name => 'Zweiter Gruppe H', :group=> nil, :round => Game::ROUND_OF_16},
      {:start_at => '01.07.2014 18:00', :api_match_id => 1417873, :place => 'São Paulo', :team1_placeholder_name => 'Sieger Gruppe F', :team2_placeholder_name => 'Zweiter Gruppe E', :group=> nil, :round => Game::ROUND_OF_16},
      {:start_at => '01.07.2014 22:00', :api_match_id => 1417874, :place => 'Salvador', :team1_placeholder_name => 'Sieger Gruppe H', :team2_placeholder_name => 'Zweiter Gruppe G', :group=> nil, :round => Game::ROUND_OF_16},

      # Viertelfinale
      {:start_at => '04.07.2014 18:00', :api_match_id => 1417876, :place => 'Rio de Janeiro', :team1_placeholder_name => 'Sieger AF 5', :team2_placeholder_name => 'Sieger AF 6', :group=> nil, :round => Game::QUARTERFINAL},
      {:start_at => '04.07.2014 22:00', :api_match_id => 1417875, :place => 'Fortaleza', :team1_placeholder_name => 'Sieger AF 1', :team2_placeholder_name => 'Sieger AF 2', :group=> nil, :round => Game::QUARTERFINAL},
      {:start_at => '05.07.2014 18:00', :api_match_id => 1417878, :place => 'Brasília', :team1_placeholder_name => 'Sieger AF 7', :team2_placeholder_name => 'Sieger AF 8', :group=> nil, :round => Game::QUARTERFINAL},
      {:start_at => '05.07.2014 22:00', :api_match_id => 1417877, :place => 'Salvador', :team1_placeholder_name => 'Sieger AF 3', :team2_placeholder_name => 'Sieger AF 4', :group=> nil, :round => Game::QUARTERFINAL},

      # Halbfinale
      {:start_at => '08.07.2014 22:00', :api_match_id => 1417879, :place => 'Belo Horizonte', :team1_placeholder_name => 'Sieger VF 1', :team2_placeholder_name => 'Sieger VF 2', :group=> nil, :round => Game::SEMIFINAL},
      {:start_at => '09.07.2014 22:00', :api_match_id => 1417880, :place => 'São Paulo', :team1_placeholder_name => 'Sieger VF 4', :team2_placeholder_name => 'Sieger VF 3', :group=> nil, :round => Game::SEMIFINAL},

      # Spiel um Platz 3
      {:start_at => '12.07.2014 22:00', :api_match_id => 1417881, :place => 'Brasília', :team1_placeholder_name => 'Verlierer HF 1', :team2_placeholder_name => 'Verlierer HF 2', :group=> nil, :round => Game::PLACE_3},

      # Finale
      {:start_at => '13.07.2014 21:00', :api_match_id => 1417882, :place => 'Rio de Janeiro', :team1_placeholder_name => 'Sieger HF 1', :team2_placeholder_name => 'Sieger HF 2', :group=> nil, :round => Game::FINAL},
  ]
end


def create_team_and_game_data
  country_codes = country_code_map

  game_data.each do |data|
    team1_name = data[:team1_name].present? ? data.delete(:team1_name) : nil
    team2_name = data[:team2_name].present? ? data.delete(:team2_name) : nil
    team_ids = {}
    if team1_name.present?
      team1 = Team.find_or_create_by_name(team1_name)
      team1.update_column(:country_code, country_codes[team1_name])
      team_ids = team_ids.merge({:team1_id => team1.id})
    end
    if team2_name.present?
      team2 = Team.find_or_create_by_name(team2_name)
      team2.update_column(:country_code, country_codes[team2_name])
      team_ids = team_ids.merge({:team2_id => team2.id})
    end

    Game.create!(data.merge(team_ids))
  end

end

puts 'Lade seeds'

# puts 'Alles loeschen...'
# Achtung nicht in production aufrufen clear_seeds

puts 'Spiele neu aufsetzen...'
# TODO soeren 21.05.12 zur Sicherheit auskommentiert
clear_games
create_team_and_game_data

puts 'fertsch!'

