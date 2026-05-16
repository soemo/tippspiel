class AddIndexToTipsUserIdAndTipPoints < ActiveRecord::Migration[6.1]
  def change
    add_index :tips, [:user_id, :tip_points], name: 'index_tips_on_user_id_and_tip_points'
  end
end
