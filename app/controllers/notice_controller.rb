class NoticeController < ApplicationController

  def index
    @notes = Notice.all
  end

end
