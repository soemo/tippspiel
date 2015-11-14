class AddRankingToTip < ActiveRecord::Migration
  def change
    add_column :tips, :ranking_place, :integer
  end
end
