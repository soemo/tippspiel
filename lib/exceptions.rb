#
# Behandelt alle Exceptions, auf die im ApplicationController gesondert reagiert werden soll
#
#
module ExceptionHandling

  def self.included base
    base.class_eval do
      # Achtung! Die Liste der Exceptions wird von unten nach oben durchgegangen - die allgemeinste Exception
      # muss also nach oben!
      rescue_from ::Exception, :with => :show_javascript_errors
      rescue_from ActionController::RoutingError, :with => :rescue_404
      rescue_from ::ActionController::InvalidAuthenticityToken, :with => :redirect_after_wrong_auth_token
      rescue_from ::ActiveRecord::StaleObjectError, :with => :redirect_after_stale_object_error
      rescue_from ::ActiveRecord::RecordNotFound, :with => :redirect_after_record_not_found
      rescue_from ::TippspielError, ::ActionView::TemplateError, :with => :redirect_after_tippspiel_error

    end
  end

  # nutzt das Gem vidibus-routing_error
  def rescue_404 exception
    # der Fehler fliegt z.B. auch, wenn man in einem link_to eine ungueltige Ziel-URL setzt
    Rails.logger.error(exception) if Rails.logger.present?
    respond_to do |type|
      type.all { render :file => "public/404.html", :status => 404, :layout => false }
    end
  end

  # es wird ein TippspielError abgefangen.
  # Da dieser auch ab und an in Templates/Partials geworfen wird, kann hier auch ein TemplateError reingegeben werden
  def redirect_after_tippspiel_error exception
    if exception.is_a?(ActionView::TemplateError)
      exception = exception.original_exception

      # Andere Fehler sind nach wie vor Programmier-Fehler
      unless exception.is_a?(TippspielError)
        raise exception
      end
    end
    redirect_all_formats exception, exception.message, get_controller_from_tab
  end

  def redirect_after_stale_object_error exception
    redirect_all_formats exception, :error_stale_object, get_controller_from_tab
  end

  def redirect_after_record_not_found exception
    redirect_all_formats exception, :error_record_not_found
  end

  def redirect_after_wrong_auth_token exception
    redirect_all_formats exception, :error_auth_token
  end

  def redirect_all_formats exception, message, controller = get_controller_from_tab
    flash[:error] = (message.is_a?(Symbol)) ? t(message) : message
    Rails.logger.info exception

    respond_to do |format|
      # params dann sinnvoll, wenn redirect innerhalb einer Componente passiert
      redirect_target = {:controller => controller, :action => 'index', :params => {}}

      format.html { redirect_to redirect_target }
      format.xml { redirect_to redirect_target }
      format.js do
        render :update do |page|
          page.redirect_to(redirect_target)
        end
      end
    end
  end

  def get_controller_from_tab
    "/dashboard"
  end

  # Behandelt alle Fehler, falls ein Javascript-Request vorliegt
  def show_javascript_errors(exception)
    std_error_msg = t(:error_ajax_request)

    if request.format == :js
      # JS-Requests werden behandelt:
      # Development => Wird auf "index"-Action weitergeleitet und Exception-Text angezeigt (Exception wird geloggt)
      # Production  => Wird auf "index"-Action weitergeleitet und "Es ist ein unbekannter Fehler aufgetreten!" (Exception wird geloggt)
      Rails.logger.error(exception) if Rails.logger.present?

      if (ENV['RAILS_ENV'] == 'development')
        flash[:error] = exception.message
      else
        flash[:error] = std_error_msg

        # TODO soeren 20.07.11 Wenn wir das Exception Notifier Plugin drin haben diese Zeilen aktivieren
        #request.format = :html
        #notify_about_exception(exception)
        #request.format = :js
      end
      controller = get_controller_from_tab
      render :update do |page|
        # nicht der aktuelle Controller, da der Nutzer eventuell dafuer keine Berechtigung hat
        page.redirect_to({:controller => controller, :action => :index})
      end
    else
      raise exception
    end
  end
end


class TippspielError < StandardError
end

