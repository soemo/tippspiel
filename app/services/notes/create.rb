# -*- encoding : utf-8 -*-
module Notes
  class Create < BaseService

    attribute :notice_text, String
    attribute :current_user_id, Integer


    def call
      create
    end


    private

    def create
      error_msg = ''

      if notice_text.present?
        notice = Notice.new({:text => notice_text, :user_id => current_user_id })
        if correct_spaces?
          unless notice.save
            error_msg = notice.errors.to_a.to_sentence
          end
        else
          error_msg = I18n.t(:notice_needs_spaces)
        end
      else
        error_msg = I18n.t(:notice_needs_a_comment)
      end

      error_msg
    end

    # ich will verhindern, das man einfach 200 Zeichen lang a drückt und das Layout zerschiesst
    def correct_spaces?
      max_size = Notice::MAX_SIZE_WITHOUT_SPACES
      notice_text.present? &&
          ((notice_text.size > max_size && notice_text.include?(" ")) ||
          notice_text.size <= max_size)
    end

  end
end