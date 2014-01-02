# -*- encoding : utf-8 -*-
#
# Behandelt alle Exceptions, auf die im ApplicationController gesondert reagiert werden soll
# rescue_from ActionController::RoutingError, :with => :rescue_404 musste in den application_controoler.rb und die route.rb ausgelagert werden #2498
#
module ExceptionHandling

  def self.included base
    base.class_eval do
      # Achtung! Die Liste der Exceptions wird von unten nach oben durchgegangen - die allgemeinste Exception
      # muss also nach oben!
      rescue_from ::Exception, :with => :show_javascript_errors
      rescue_from ::ActionController::InvalidAuthenticityToken, :with => :redirect_after_wrong_auth_token
      rescue_from ::CanCan::AccessDenied, :with => :redirect_after_access_denied
      rescue_from ::ActiveRecord::StaleObjectError, :with => :redirect_after_stale_object_error
      rescue_from ::ActiveRecord::RecordNotFound, :with => :redirect_after_record_not_found
      rescue_from ::TippspielError, ::ActionView::TemplateError, :with => :redirect_after_tippspiel_error
    end
  end

  #wird aufgerufen duch die route match '*a', :to => 'application#rescue_404' in routes.rb
  def rescue_404
    # der Fehler fliegt z.B. auch, wenn man in einem link_to eine ungueltige Ziel-URL setzt
    Rails.logger.error("ERROR rescue_404 mit Params: #{params["a"]}") if Rails.logger.present?
    respond_to do |format|
      format.all { render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false}
    end
  end

  # es wird ein TippspielError abgefangen.
  # Da dieser auch ab und an in Templates/Partials geworfen wird, kann hier auch ein TemplateError reingegeben werden
  def redirect_after_tippspiel_error exception
    if exception.is_a?(ActionView::TemplateError)
      exception = exception.original_exception
    end
    redirect_all_formats exception, exception.message, false, get_redirect_controller
  end

  def redirect_after_stale_object_error exception
    redirect_all_formats exception, :error_stale_object, false, get_url_for_stale_error
  end

  # nutzen wenn ich cancan nutze
  def redirect_after_access_denied exception
    redirect_all_formats exception, :error_access_denied, false, get_redirect_controller
  end

  def redirect_after_record_not_found exception
    redirect_all_formats exception, :error_record_not_found
  end

  def redirect_after_wrong_auth_token exception
    redirect_all_formats exception, :error_auth_token
  end

  def redirect_all_formats exception, message, reraise_error = false, controller_or_url_hash = get_redirect_controller
    flash[:error] = (message.is_a?(Symbol)) ? t(message) : message
    Rails.logger.error exception.message
    Rails.logger.error exception.backtrace.inspect
    if (Rails.env == "test" || Rails.env == "development") && reraise_error
      # Im Test wollen wir Fehler direkt mitbekommen
      raise exception
    else
      respond_to do |format|
        if controller_or_url_hash.is_a?(Hash)
          redirect_target = controller_or_url_hash
        else
          # params dann sinnvoll, wenn redirect innerhalb einer Componente passiert
          redirect_target = {:controller => controller_or_url_hash, :action => get_redirect_action, :params => {}}
        end

        format.html { redirect_to redirect_target }
        format.xml { redirect_to redirect_target }
        format.js { render :template => "/unknown_error", :locals => {:redirect_target => redirect_target}}
      end
    end
  end

  # Geht davon aus, das StaleObjectErrors immer in einer :update-Action fliegen und leitet auf die
  # entsprechende :edit-Action weiter. Sonderfaelle muessen hier entsprechend eingetragen werden, sobald sie
  # auftauchen.
  def get_url_for_stale_error
    {:action => :edit}
  end

  def get_redirect_controller
    "/main"
  end

  def get_redirect_action
    "error"
  end

  # Behandelt alle Fehler, falls ein Javascript-Request vorliegt
  def show_javascript_errors(exception)
    std_error_msg = t(:error_ajax_request)
    if request.format == :js
      # JS-Requests werden behandelt:
      # Development => Wird auf get_redirect_action weitergeleitet und Exception-Text angezeigt (Exception wird geloggt)
      # Production  => Wird auf get_redirect_action weitergeleitet und "Es ist ein unbekannter Fehler aufgetreten!" (Exception wird geloggt)
      if Rails.logger.present?
        Rails.logger.error(exception)
        Rails.logger.error(exception.backtrace.inspect)
      end

      if (Rails.env == 'development')
        flash[:error] = exception.message
      elsif (Rails.env == 'test')
        raise exception
      else
        flash[:error] = std_error_msg

        request.format = :html
        notify_airbrake(exception)
        request.format = :js
      end
      controller = get_redirect_controller
      redirect_target = {:controller => controller, :action => get_redirect_action, :params => {}}
      render :template => "/unknown_error", :locals => {:redirect_target => redirect_target}
    else
      notify_airbrake(exception)
      redirect_all_formats exception, std_error_msg, true
    end
  end
end


class TippspielError < StandardError
end
