class CreateSchedulerRuns < ActiveRecord::Migration
  def self.up
    create_table :scheduler_runs do |t|
      t.string :schedule
      t.timestamps
    end
  end

  def self.down
    drop_table :scheduler_runs
  end
end
