# !!!!!!!!!!!!!!!!!!!
# !!! ATTENTION   !!!
# !!!!!!!!!!!!!!!!!!!
# IF CLEAR_SEEDS IS SET TO TRUE YOU ERASE YOUR
# MANUALLY CREATED DATA

CLEAR_SEEDS = false

def clear_seeds()
  Day.delete_all
  Group.delete_all
  Place.delete_all
  Poll.delete_all
  Round.delete_all
  Starttime.delete_all
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

def create_group
  ["A", "B", "C", "D"].each do |i|
    Group.find_or_create_by_name(i)
  end
end

def create_place
  ["Place A", "Place B", "Place C", "Place D"].each do |i|
    Place.find_or_create_by_name(i)
  end
end

def create_poll
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

def create_round

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

def create_starttime
  [
          "16:00", "20:00"
  ].each do |i|
    Starttime.find_or_create_by_name(i)
  end
end

if CLEAR_SEEDS
  clear_seeds
end

create_days
create_group
create_place
create_poll
create_round
create_starttime

