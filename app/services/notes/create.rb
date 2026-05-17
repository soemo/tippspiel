# frozen_string_literal: true

module Notes
  class Create < BaseService
    attribute :notice_text
    attribute :current_user_id

    def call
      create
    end

    private

    def create
      error_msg = ''

      if notice_text.present?
        notice = Notice.new({ text: notice_text, user_id: current_user_id })

        error_msg = notice.errors.to_a.to_sentence unless notice.save
      else
        error_msg = I18n.t(:notice_needs_a_comment)
      end

      error_msg
    end
  end
end
