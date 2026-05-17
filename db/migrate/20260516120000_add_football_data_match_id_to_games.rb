# frozen_string_literal: true

class AddFootballDataMatchIdToGames < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :football_data_match_id, :integer
    add_index  :games, :football_data_match_id, unique: true
  end
end
