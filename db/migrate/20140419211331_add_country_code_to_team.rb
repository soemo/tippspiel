class AddCountryCodeToTeam < ActiveRecord::Migration
  def up
    remove_column :teams, :flag_image_url
    add_column :teams, :country_code, :string
  end

  def down
    remove_column :teams, :country_code
    add_column :teams, :flag_image_url, :string
  end
end
