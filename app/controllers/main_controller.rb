class MainController < ApplicationController

  def index
    tips = Tips::FromUser.call(user_id: current_user.id)
    @presenter = MainIndexPresenter.new(tips, current_user)
  end
end
