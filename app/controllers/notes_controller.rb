class NotesController < ApplicationController

  def index
    @notice = Notice.new
    @notes = NoticeQueries.order_by_created_at_asc
  end

  def create
    respond_to do |format|
      error_msg = Notes::Create.call(notice_text: params[:text],
                                     current_user_id: current_user.id)

      if error_msg.present?
        flash[:error] = error_msg
      else
        flash[:notice] = t(:create_successful, :object_name => Notice.model_name.human)
      end

      format.html { redirect_to :action => "index" }
    end
  end

end
