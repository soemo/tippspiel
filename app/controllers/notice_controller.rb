class NoticeController < ApplicationController

  def index
    @notice = Notice.new
    @notes = Notice.all
  end

  def create
    respond_to do |format|
      if params[:text].present?
        @notice = Notice.new({:text => params[:text], :user_id => current_user.id })
        if @notice.correct_spaces?
          if @notice.save
            flash[:notice] = t(:create_successful, :object_name => Notice.model_name.human)
          end # no else
        else
          flash[:error] = t(:notice_needs_spaces)
        end
      else
        flash[:error] = t(:notice_needs_a_comment)
      end

      format.html { redirect_to :action => "index" }
    end
  end

end
