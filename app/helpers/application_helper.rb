module ApplicationHelper

  def get_title
    "#{TOURNAMENT_NAME} #{t('app_name')}"
  end

  # flag_suze: 16 or 32
  # flag_position: left or right
  def team_with_flag(team_name:, country_code: , flag_size: 32, flag_position: 'left')
    flag = teamflag(country_code, flag_size)
    case flag_position
      when 'left'
        raw "#{flag} #{team_name}"
      when 'right'
        raw "#{team_name} #{flag}"
      else
        raise "Wrong flag_position #{flag_position}"
    end
  end

  def teamflag(country_code, flag_size)
    flag_span_css_class = "f#{flag_size}"
    "<span class='#{flag_span_css_class}'><i class='flag #{country_code}'</i></span>"
  end

  def write_flash_messages
    haml_tag 'div#flash_messages' do
      write_flash(flash[:error], 'alert')
      write_flash(flash[:alert], 'alert')
      write_flash(flash[:notice], 'success')
    end

    flash.discard
  end

  def write_flash(msg, div_alert_css_class)
    if msg.kind_of?(Array)
      if msg.size > 1
        raise "Mehrelementige Textparameter verboten: #{msg}"
      else
        msg = msg.first
      end
    end

    if msg.present?
      haml_tag "div.alert-box.#{div_alert_css_class}", data: {closable: ''} do
        haml_concat msg
        haml_tag 'button.close-button', {data: {close: ''}} do
          haml_concat '&times;'
        end

      end
    end
  end

  def is_selected_controller?(link_controller_name)
    if link_controller_name.present?
      link_controller_name = link_controller_name.gsub('-', '_')
      controller_name = controller.controller_name
      link_controller_name.pluralize == controller_name || link_controller_name == controller_name
    else
      false
    end
  end

  def get_user_name_or_sign_in_link
    if user_signed_in?
      hello_user_name
    else
      link_to(t(:sign_up), new_user_registration_path)
    end
  end

  def hello_user_name
    "#{t(:signed_in_hello)} #{current_user.firstname}"
  end


  def write_footer_content
     haml_tag 'p.text-center' do
       haml_concat "© " + Time.now.strftime("%Y")
       haml_concat link_to("Sören Mothes", "http://www.soemo.org/")
       haml_concat " | "
       haml_concat link_to(t(:imprint), help_path + "#imprint")
       haml_concat " |  version #{$TIPPSPIEL_VERSION} - #{$TIPPSPIEL_BUILD_DATE}"
     end
  end

end
