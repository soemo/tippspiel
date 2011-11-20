class UserIndexNonUnique < ActiveRecord::Migration

  # Email darf auf der DB nicht unique sein, da das mit acts_as_paranoid kollidiert
  def up
    remove_index 'users', :email
    add_index    'users', :email
  end

  def down
    remove_index 'users', :email
    add_index 'users', :email,                :unique => true
  end

end
