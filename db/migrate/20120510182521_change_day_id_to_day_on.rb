# -*- encoding : utf-8 -*-
class ChangeDayIdToDayOn < ActiveRecord::Migration
  def up
    remove_column :statistics, :day_id
    add_column :statistics, :date_on, :date, :null => false
  end

  def down
    remove_column :statistics, :date_on
    add_column :statistics, :day_id, :integer
  end
end
