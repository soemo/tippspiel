# -*- encoding : utf-8 -*-
class RemoveGoodFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :good
  end

  def down
    add_column :users, :good, :integer
  end
end
