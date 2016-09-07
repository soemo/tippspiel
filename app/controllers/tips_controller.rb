class TipsController < ApplicationController

  def save_tips
    Tips::Save.call(tips_params: params[:tips], current_user: current_user)
    msg =  params[:tips].present? ? t('succesfully_saved_tips') : ''
    redirect_to(root_path, {notice: msg})
  end
end
