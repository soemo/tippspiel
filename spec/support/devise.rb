module LoginUserHelper
  # Loggt den angegebenen User ein (wenn kein User angegeben wird, erfolgt der Login als Default User)
  def login(user=create(:user))
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
    expect(subject.current_user).not_to be_nil unless user.new_record?
    user
  end

  def logout(user)
    sign_out user
  end
end

# module for helping request specs
module LoginUserRequestHelper
  def login(user)
    post_via_redirect user_session_path, 'user[email]' => user.email, 'user[password]' => user.password
  end
end

RSpec.configure do |config|
  config.include LoginUserHelper,        :type => :controller
  config.include LoginUserRequestHelper, :type => :request
  config.include Devise::TestHelpers,    :type => :controller # fuer sign_in und sign_out Helper
end
