class RemoveSchedulerRuns < ActiveRecord::Migration
  def up
    drop_table :scheduler_runs
  end

  def down
    # do nothing
  end
end
