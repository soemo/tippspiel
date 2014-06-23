class DeleteStatistics < ActiveRecord::Migration
  def up
    drop_table :statistics
  end

  def down
    # nothing to do
  end
end
