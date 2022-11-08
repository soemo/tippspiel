class RenameUserChampiontippoints < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :championtippoints, :bonus_points
  end
end
