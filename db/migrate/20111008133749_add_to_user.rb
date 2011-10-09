class AddToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
    add_column :users, :points, :integer
    add_column :users, :good, :integer
    add_column :users, :count6points, :integer
    add_column :users, :count4points, :integer
    add_column :users, :count3points, :integer
    add_column :users, :count0points, :integer
    add_column :users, :championtipppoints, :integer
    add_column :users, :championtipp_team_id, :integer
    add_column :users, :poll_id, :integer
  end

  def self.down
    remove_column :users, :firstname
    remove_column :users, :lastname
    remove_column :users, :points
    remove_column :users, :good
    remove_column :users, :count6points
    remove_column :users, :count4points
    remove_column :users, :count3points
    remove_column :users, :count0points
    remove_column :users, :championtipppoints
    remove_column :users, :championtipp_team_id
    remove_column :users, :poll_id
  end
end
