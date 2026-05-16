class CreateAppSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :app_settings, charset: "utf8mb4", collation: "utf8mb4_unicode_ci" do |t|
      t.string :key, null: false
      t.string :value

      t.timestamps
    end
    add_index :app_settings, :key, unique: true
  end
end
