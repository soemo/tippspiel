# -*- encoding : utf-8 -*-
class AddFinishedToGame < ActiveRecord::Migration
  def change
    add_column :games, :finished, :boolean, :default => 0
  end
end
