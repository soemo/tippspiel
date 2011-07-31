module ControllerMacros
  def spec_login_admin email="admin@test.de"
    before :each do
      user = User.find_by_email(email)
      raise "could not find user with email #{email}" if user.nil?
      user.confirm!
      sign_in user # der geht trotzdem auf den :user-Scope!
    end
  end

  def spec_login_user email="user@test.de"
    before :each do
      user = User.find_by_email(email)
      raise "could not find user with email #{email}" if user.nil?
      user.confirm!
      sign_in user
    end
  end

  def activate_devise_without_login
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end
  end
end