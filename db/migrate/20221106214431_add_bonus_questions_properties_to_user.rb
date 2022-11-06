class AddBonusQuestionsPropertiesToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :bonus_second_team_id, :integer
    add_column :users, :bonus_how_many_goals, :integer
    add_column :users, :bonus_when_final_first_goal, :integer
    rename_column :users, :championtip_team_id, :bonus_champion_team_id
  end
end
