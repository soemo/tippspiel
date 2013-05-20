class DeleteSchedulerRuns < ActiveRecord::Migration
  def up
    drop_table :scheduler_runs
  end

  def down
    create_table :scheduler_runs do |t|
      t.string :schedule
      t.timestamps
    end
  end
end
