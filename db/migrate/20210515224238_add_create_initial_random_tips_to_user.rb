class AddCreateInitialRandomTipsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :create_initial_random_tips, :boolean, default: false
  end
end
