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

        unless notice.save
          error_msg = notice.errors.to_a.to_sentence
        end
      else
        error_msg = I18n.t(:notice_needs_a_comment)
      end

      error_msg
    end


  end
end