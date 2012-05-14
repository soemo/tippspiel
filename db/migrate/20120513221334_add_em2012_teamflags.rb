class AddEm2012Teamflags < ActiveRecord::Migration

  class Team < ActiveRecord::Base;end

  def up
    teams = Team.all
    if teams.present?
      teams.each do |team|
        team.update_attribute(:flag_image_url, team_flags[team.name])
      end
    end
  end

  def team_flags
    {
            'Polen' => 'flags/pl.gif',
            'Griechenland' => 'flags/gr.gif',
            'Russland' => 'flags/ru.gif',
            'Tschechien' => 'flags/cz.gif',
            'Niederlande' => 'flags/nl.gif',
            'Dänemark' => 'flags/dk.gif',
            'Deutschland' => 'flags/de.gif',
            'Portugal' => 'flags/pt.gif',
            'Spanien' => 'flags/es.gif',
            'Italien' => 'flags/it.gif',
            'Irland' => 'flags/ie.gif',
            'Kroatien' => 'flags/hr.gif',
            'Frankreich' => 'flags/fr.gif',
            'England' => 'flags/gb.gif',
            'Ukraine' => 'flags/ua.gif',
            'Schweden' => 'flags/se.gif',
    }
  end


  def down
    Team.update_all("flag_image_url=''")
  end

end
