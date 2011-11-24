class DeleteModels < ActiveRecord::Migration
  def up
    change_column :starttimes, :name, :datetime
    add_column :games, :round, :string, :limit=>30
    add_column :games, :group, :string, :limit=>30
    add_column :games, :place, :string, :limit=>30

    drop_table :days
    drop_table :places
    drop_table :groups
    drop_table :rounds
  end

  def down
     # nothing to do
  end
end
