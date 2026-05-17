# frozen_string_literal: true

module ApplicationHelper
  def get_title # rubocop:disable Naming/AccessorMethodName -- legacy helper name used in views and presenters
    "#{I18n.t('tournament_name')} #{I18n.t('app_name')}"
  end

  def hall_of_fame_link
    link_to(icon('fas', 'trophy', I18n.t(:hall_of_fame), { class: 'fa-fw' }), hall_of_fame_path)
  end

  # Structured filter sections for the mixitup dropdown filter.
  # Each section has a translated title and a list of options
  # ({label, data_filter}). The "all" option in the status section
  # is the default and uses the literal mixitup "all" selector.
  def tip_filter_sections # rubocop:disable Metrics/MethodLength -- data structure builder, splitting into helpers would obscure intent
    [
      {
        title: I18n.t('filter.section.status'),
        options: FILTER_CATEGORIES.map do |filter_category|
          {
            label: I18n.t("filter.#{filter_category}"),
            data_filter: filter_category == FILTER_DEFAULT ? 'all' : ".category-#{filter_category}",
            default: filter_category == FILTER_DEFAULT
          }
        end
      },
      {
        title: I18n.t('filter.section.group'),
        options: GROUPS.map do |group|
          {
            label: "#{I18n.t('round.group')} #{group}",
            data_filter: ".category-#{FILTER_GROUP_PREFIX}#{group}",
            default: false
          }
        end
      },
      {
        title: I18n.t('filter.section.round'),
        options: ROUNDS.reject { |r| r == GROUP }.map do |round|
          {
            label: I18n.t(round, scope: 'round'),
            data_filter: ".category-#{FILTER_ROUND_PREFIX}#{round}",
            default: false
          }
        end
      }
    ]
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
    if msg.is_a?(Array)
      raise "Mehrelementige Textparameter verboten: #{msg}" if msg.size > 1

      msg = msg.first

    end

    return if msg.blank?

    haml_tag "div.alert-box.#{div_alert_css_class}", data: { closable: '' } do
      haml_concat msg
      haml_tag 'button.close-button', { data: { close: '' } } do
        haml_concat '&times;'.html_safe
      end
    end
  end

  def write_footer_content
    haml_tag 'p.text-center' do
      haml_concat "© #{Time.zone.now.strftime('%Y')}"
      haml_concat 'Sören Mothes'
      haml_concat ' | '
      haml_concat link_to(t(:help), help_path)
      haml_concat ' | '
      haml_concat link_to(t(:imprint), imprint_path)
      haml_concat " |  version #{$TIPPSPIEL_VERSION} - #{$TIPPSPIEL_BUILD_DATE}" # -- injected by config/version.rb and config/environments/*.rb
    end
  end

  def your_tips_link
    link_to(icon('fas', 'edit', I18n.t(:your_tips), { class: 'fa-fw' }), root_path)
  end

  # Renders a coloured correct/wrong label for a bonus answer.
  # Pass `answer_set: false` for questions 3 & 4 when the admin has not yet
  # stored the correct answer — shows a neutral "not yet evaluated" label.
  def bonus_result_tag(correct, answer_set: true)
    points = TipPoints::BONUS
    if correct
      content_tag(:span, I18n.t('bonus_answer_correct', points: points), class: 'label success')
    elsif !answer_set
      content_tag(:span, I18n.t('bonus_answer_not_set'), class: 'label secondary')
    else
      content_tag(:span, I18n.t('bonus_answer_wrong'), class: 'label alert')
    end
  end
end
