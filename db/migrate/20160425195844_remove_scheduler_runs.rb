class RemoveSchedulerRuns < ActiveRecord::Migration
  def up
    if ActiveRecord::Base.connection.table_exists? 'scheduler_runs'
      drop_table :scheduler_runs
    end
  end

  def down
    # do nothing
  end
end
