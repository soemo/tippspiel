# -*- encoding : utf-8 -*-
module ControllerMacros

  def spec_login_user(email='user@test.de')
    before :each do
      @user = create(:user, email: email)
      @user.confirm!
      sign_in @user
    end
  end

  def activate_devise_without_login
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
    end
  end
end
