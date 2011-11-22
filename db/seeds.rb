require File.expand_path('../seeds_data.rb', __FILE__)

include SeedsData

# ***************************************************************************
# Achtung: Alle angelegten Daten werden bei seeds.rb Ausfuehrung geloescht!
# ***************************************************************************

def clear_seeds
  # Alle Tabellen (inkl. N:M-Tabellen) werden geloescht
  ActiveRecord::Base.connection.tables.each do |table|
    next if ["schema_migrations", "users", "admin_users"].include?(table)
    ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
  end

  # TODO soeren 22.11.11 user löschen, die testuser im nachnamen haben
end


def game_data
  [
    {"day" => "08.06.2012", "time" => "18:00", "place" => "Warschau"}


  ]



=begin
Gruppe A
Anstoß Ort Mannsch. I Mannsch. II Erg.
Fr 08.06. 18:00 Warschau Polen - A2 -:- (-:-)
Fr 08.06. 20:45 Wroclaw A3 - A4 -:- (-:-)
Di 12.06. 18:00 Wroclaw A2 - A4 -:- (-:-)
Di 12.06. 20:45 Warschau Polen - A3 -:- (-:-)
Sa 16.06. 20:45 Wroclaw A4 - Polen -:- (-:-)
Warschau A2 - A3 -:- (-:-)

Gruppe B
Anstoß Ort Mannsch. I Mannsch. II Erg.
Sa 09.06. 18:00 Charkiw B1 - B2 -:- (-:-)
Sa 09.06. 20:45 Lw iw B3 - B4 -:- (-:-)
Mi 13.06. 18:00 Lw iw B2 - B4 -:- (-:-)
Mi 13.06. 20:45 Charkiw B1 - B3 -:- (-:-)
So 17.06. 20:45 Charkiw B4 - B1 -:- (-:-)
Lw iw B2 - B3 -:- (-:-)

Gruppe C
Anstoß Ort Mannsch. I Mannsch. II Erg.
So 10.06. 18:00 Gdansk C1 - C2 -:- (-:-)
So 10.06. 20:45 Poznan C3 - C4 -:- (-:-)
Do 14.06. 18:00 Poznan C2 - C4 -:- (-:-)
Do 14.06. 20:45 Gdansk C1 - C3 -:- (-:-)
Mo 18.06. 20:45 Gdansk C4 - C1 -:- (-:-)
Poznan C2 - C3 -:- (-:-)

Gruppe D
Anstoß Ort Mannsch. I Mannsch. II Erg.
Mo 11.06. 18:00 Donezk D3 - D4 -:- (-:-)
Mo 11.06. 20:45 Kiew Ukraine - D2 -:- (-:-)
Fr 15.06. 18:00 Kiew D2 - D4 -:- (-:-)
Fr 15.06. 20:45 Donezk Ukraine - D3 -:- (-:-)
Di 19.06. 20:45 Donezk D4 - Ukraine -:- (-:-)
Kiew D2 - D3 -:- (-:-)

Viertelfinale
Anstoß Ort Mannsch. I Mannsch. II Erg.
Do 21.06. 20:45 Warschau Sieger Gruppe A - Zweiter Gruppe B -:- (-:-)
Fr 22.06. 20:45 Gdansk Sieger Gruppe B - Zweiter Gruppe A -:- (-:-)
Sa 23.06. 20:45 Donezk Sieger Gruppe C - Zweiter Gruppe D -:- (-:-)
So 24.06. 20:45 Kiew Sieger Gruppe D - Zweiter Gruppe C -:- (-:-)

Halbfinale
Anstoß Ort Mannsch. I Mannsch. II Erg.
Mi 27.06. 20:45 Donezk Sieger Viertelfinale Warschau - Sieger Viertelfinale Donezk -:- (-:-)
Do 28.06. 20:45 Warschau Sieger Viertelfinale Gdansk - Sieger Viertelfinale Kiew -:- (-:-)

Finale
Anstoß Ort Mannsch. I Mannsch. II Erg.
So 01.07. 20:45 Kiew Sieger Halbfinale 1 - Sieger Halbfinale 2 -:- (-:-)
=end
end


def create_days
  [
          "21.06.2011",
          "22.06.2012",
          "23.06.2012"
  ].each do |i|
    Day.find_or_create_by_name(i)
  end
end

def create_groups
  ["A", "B", "C", "D"].each do |i|
    Group.find_or_create_by_name(i)
  end
end

def create_places
  ["Place A", "Place B", "Place C", "Place D"].each do |i|
    Place.find_or_create_by_name(i)
  end
end

def create_polls
  [
          "nicht ins Achtelfinale",
          "ins Achtelfinale",
          "ins Viertelfinale",
          "ins Halbfinale",
          "ins Finale",
          "Weltmeister"
  ].each do |i|
    Poll.find_or_create_by_name(i)
  end
end

def create_rounds

  [
          "Gruppenspiele",
          "Achtelfinale",
          "Viertelfinale",
          "Halbfinale",
          #"Spiel um Platz 3",
          "Finale"
  ].each do |i|
    r = Round.find_or_create_by_name(i, 1, 1)
    # TODO soeren 09.10.11 muss besser werden
    r.start_day = Day.first
    r.start_day = Day.last
    r.save
  end
end

def create_starttimes
  [
          "16:00", "20:00"
  ].each do |i|
    Starttime.find_or_create_by_name(i)
  end
end

puts "Lade seeds"
puts "Alles loeschen..."
clear_seeds
puts "Neue Daten aufsetzen..."
create_days
# TODO soeren 22.11.11 create_games
create_groups
# TODO soeren 22.11.11 create_notice
create_places
create_polls
create_rounds
create_starttimes
# TODO soeren 22.11.11 create_statistics
# TODO soeren 22.11.11 create_teams
# # TODO soeren 22.11.11 create_tipps

