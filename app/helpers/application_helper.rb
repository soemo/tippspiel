module ApplicationHelper

  def get_title
    "#{I18n.t('tournament_name')} #{I18n.t('app_name')}"
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
       haml_concat 'Sören Mothes'
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

  # Renders a coloured correct/wrong label for a bonus answer.
  # Pass manual: true for questions 3 & 4 — when the AppSetting answer has not
  # been stored yet we show a neutral "not yet evaluated" label instead of "wrong".
  def bonus_result_tag(correct, manual: false)
    points = Users::UpdatePoints::BONUS_TIP_POINTS
    if correct
      content_tag(:span, I18n.t('bonus_answer_correct', points: points), class: 'label success')
    elsif manual && AppSetting.bonus_answer_how_many_goals.nil? && AppSetting.bonus_answer_when_will_the_first_goal.nil?
      content_tag(:span, I18n.t('bonus_answer_not_set'), class: 'label secondary')
    else
      content_tag(:span, I18n.t('bonus_answer_wrong'), class: 'label alert')
    end
  end

end
