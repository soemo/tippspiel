class AddNewTippPointCalculation < ActiveRecord::Migration

  # Ticket #49 Punktberechnung anpassen - 2 Punkte bei richtigen Toranzahl
  def up
    add_column :users, :count5points, :integer
    add_column :users, :count8points, :integer

    remove_column :users, :count6points
  end

  def down
    remove_column :users, :count5points
    remove_column :users, :count8points

    add_column :users, :count6points, :integer
  end
end
