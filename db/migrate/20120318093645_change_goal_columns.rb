class ChangeGoalColumns < ActiveRecord::Migration
  def up
    rename_column :games, :team1_tore, :team1_goals
    rename_column :games, :team2_tore, :team2_goals
    change_column :games, :team1_goals, :integer, :default => nil, :null => true
    change_column :games, :team2_goals, :integer, :default => nil, :null => true

    rename_column :tipps, :team1_tore, :team1_goals
    rename_column :tipps, :team2_tore, :team2_goals
    change_column :tipps, :team1_goals, :integer, :default => nil, :null => true
    change_column :tipps, :team2_goals, :integer, :default => nil, :null => true

  end

  def down
    # nothing to do
  end
end
