# -*- encoding : utf-8 -*-
class AddGameTeamPlaceholderName < ActiveRecord::Migration
  def up
    add_column :games, :team1_placeholder_name, :string
    add_column :games, :team2_placeholder_name, :string
  end

  def down
    remove_column :games, :team1_placeholder_name
    remove_column :games, :team2_placeholder_name
  end
end
