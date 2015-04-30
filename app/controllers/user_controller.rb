# -*- encoding : utf-8 -*-
class UserController < ApplicationController

  def edit_password
    session[:current_main_nav_item] = nil
    respond_to do |format|
      format.html
    end
  end
         # TODO soeren 30.04.15 use own service
  def change_password
    old_password          = params[:old_password]
    password              = params[:password]
    password_confirmation = params[:password_confirmation]
    user = current_user

    error_messages = user.valid_password_change_params(old_password, password, password_confirmation)
    if error_messages.present?
      flash[:error] = error_messages.join(' ')
    else
      if user.update_attribute(:password, password)
        # Sign in the user by passing validation in case his password changed
        sign_in user, :bypass => true
        flash[:notice] = t(:change_password_save_success)
      end
    end

    respond_to do |format|
      format.html { redirect_to :action => 'edit_password'}
    end
  end

end
