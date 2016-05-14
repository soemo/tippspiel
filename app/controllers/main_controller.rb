# -*- encoding : utf-8 -*-
class MainController < ApplicationController

  skip_before_filter :authenticate_user!

  def index
    @presenter = MainIndexPresenter.new(current_user)
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
