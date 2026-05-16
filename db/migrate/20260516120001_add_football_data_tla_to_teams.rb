class AddFootballDataTlaToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :football_data_tla, :string, limit: 3
    add_index  :teams, :football_data_tla
  end
end
