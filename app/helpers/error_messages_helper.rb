module ErrorMessagesHelper
  # Render error messages for the given objects.
  # The :message option is allowed.
  def error_messages_for(*objects)
    messages = objects.compact.map { |o| o.errors.full_messages }.flatten
    unless messages.empty?
      content_tag(:div, class: 'alert-box alert') do
        content = ''
        list_items = messages.map { |msg| content_tag(:li, msg) }
        content << content_tag(:ul, list_items.join.html_safe)
        content << content_tag(:button, 'x', class: 'close-button', data: {close: ''})
        content.html_safe
      end
    end
  end

  module FormBuilderExtensions
    def error_messages(options = {})
      @template.error_messages_for(@object, options)
    end
  end
end

ActionView::Helpers::FormBuilder.send(:include, ErrorMessagesHelper::FormBuilderExtensions)
