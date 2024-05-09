module LoginUserHelper
  # logged in the given user
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
    redirect_to post user_session_path, 'user[email]' => user.email, 'user[password]' => user.password
  end
end

RSpec.configure do |config|
  config.include LoginUserHelper,        type: :controller
  config.include LoginUserRequestHelper, type: :request
  config.include Devise::Test::ControllerHelpers,  type: :controller # for sign_in and sign_out helper
end
