module ApplicationHelper

  def get_title
    "#{TOURNAMENT_NAME} #{I18n.t('app_name')}"
  end

  def hall_of_fame_link
    link_to(icon('fas', 'trophy', I18n.t(:hall_of_fame), {class: 'fa-fw'}), hall_of_fame_path)
  end

  # used with mixitup
  def filter_categories_options
    FILTER_CATEGORIES.map do |filter_category|
      css_classes = 'filter button'
      data_filter = ".category-#{filter_category}"
      if filter_category == FILTER_DEFAULT
        css_classes << ' active'
        data_filter = 'all'
      end

      {
          label: I18n.t("filter.#{filter_category}"),
          class: css_classes,
          data_filter: data_filter
      }
    end
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
          haml_concat '&times;'.html_safe
        end

      end
    end
  end

  def write_footer_content
     haml_tag 'p.text-center' do
       haml_concat '© ' + Time.now.strftime('%Y')
       haml_concat link_to('Sören Mothes', 'https://www.soemo.org/')
       haml_concat " | "
       haml_concat link_to(t(:help), help_path)
       haml_concat " | "
       haml_concat link_to(t(:imprint), imprint_path )
       haml_concat " |  version #{$TIPPSPIEL_VERSION} - #{$TIPPSPIEL_BUILD_DATE}"
     end
  end

  def your_tips_link
    link_to(icon('fas', 'edit', I18n.t(:your_tips), {class: 'fa-fw'}), root_path)
  end

end
