class MainController < ApplicationController

  skip_before_action :authenticate_user!, only: :error

  def index
    tips = Tips::FromUser.call(user_id: current_user.id)
    @presenter = MainIndexPresenter.new(tips, current_user)
  end

  def error
    # extra Text fuer die Errorseite, aber nur wenn ein 500 Fehler fliegt
    if I18n.t(:error_internal) == flash[:error]
      @error_msg = {
          :text => t(:error_500_text)
      }
    end
  end

end
