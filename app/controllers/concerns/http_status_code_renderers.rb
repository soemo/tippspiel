module HttpStatusCodeRenderers

  def render_bad_request
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/400.html", layout: false, status: :bad_request }
      format.pdf { render file: "#{Rails.root}/public/400.html", layout: false, status: :bad_request }
      format.js { head :bad_request }
    end
  end

  def render_forbidden
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/403.html", layout: false, status: :forbidden }
      format.pdf { render file: "#{Rails.root}/public/403.html", layout: false, status: :forbidden }
      format.js { head :forbidden }
      format.json { head :forbidden }
    end
  end

  def render_success
    respond_to do |format|
      format.html { render text: '200 Ok', status: :ok }
      format.pdf { render text: '200 Ok', status: :ok }
      format.js { head :ok }
    end
  end
end