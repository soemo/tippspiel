# -*- encoding : utf-8 -*-
require 'rails_helper'

describe UserController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { {  } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # UsersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'password' do
    before :each do
      @user = FactoryGirl.create(:active_user)
      sign_in @user
    end

    it 'should change password' do
      old_encrypted_password = @user.encrypted_password

      new_password = 'secret42'
      post 'change_password', {:old_password => 'secret123', # das steht in der Factory zur Erstellung drin
                               :password => new_password,
                               :password_confirmation => new_password}
      expect(response).to redirect_to user_edit_password_path
      expect(flash[:error]).to eq(nil)
      expect(flash[:notice]).to eq(I18n.t('change_password_save_success'))

      check_user = User.find(@user.id)
      expect(check_user.encrypted_password).not_to eq(old_encrypted_password)
    end

    it 'should not change password' do
      new_password = 'secret42'

      [
          [nil, nil, nil],
          ['', '', ''],
          ['test', '', ''],
          ['test', 'test', ''],
          ['', 'test', ''],
          ['', 'test', 'test'],
          ['', '', 'test'],
          ['test', '', 'test']
      ].each do |old, pw, pw_confirmation|
        post 'change_password', {:old_password => '', :password => '', :password_confirmation => ''}
        expect(response).to redirect_to user_edit_password_path
        expect(flash[:error]).to include(I18n.t('change_password_need_all_input_fields'))
      end

      post 'change_password', {:old_password => 'secret123', # das steht in der Factory zur Erstellung drin
                               :password => new_password,
                               :password_confirmation => new_password+'wrong_addon_part'}
      expect(response).to redirect_to user_edit_password_path
      expect(flash[:error]).to eq(I18n.t('change_password_wrong_pw_confirmation'))

      post 'change_password', {:old_password => 'WRONG_OLD_PW',
                               :password => new_password,
                               :password_confirmation => new_password}
      expect(response).to redirect_to user_edit_password_path
      expect(flash[:error]).to eq(I18n.t('change_password_wrong_old_pw'))

    end
  end
end
