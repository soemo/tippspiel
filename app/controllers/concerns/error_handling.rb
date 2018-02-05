module ErrorHandling

  def self.included(base)
    base.class_eval do
      rescue_from ActionController::InvalidAuthenticityToken, with: :handle_invalid_authenticity
      rescue_from ActiveRecord::StaleObjectError, with: :handle_stale_object_error
    end
  end

  def handle_invalid_authenticity
    respond_to do |format|
      format.html { redirect_to(root_path, flash: {error: t(:error_auth_token)}) }
      format.json { head :unprocessable_entity }
    end
  end

  def handle_stale_object_error
    respond_to do |format|
      # We assume that StaleObjectError only occurs in update action thus redirect to edit is just fine
      format.html { redirect_to({action: :edit}, flash: {error: t(:error_stale_object)}) }
      format.json { head :conflict }
    end
  end
end