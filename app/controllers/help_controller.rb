# -*- encoding : utf-8 -*-
class HelpController < ApplicationController

  skip_before_filter :authenticate_user!

  def index
  end

end
