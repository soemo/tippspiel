# -*- encoding : utf-8 -*-
class Notice < ActiveRecord::Base
  acts_as_paranoid
  stores_emoji_characters :text

  MAX_SIZE = 200
  MAX_SIZE_WITHOUT_SPACES = 100

  belongs_to :user

  validates_presence_of :text
  validates_length_of :text, :maximum => MAX_SIZE
  validates_presence_of :user

  validate :correct_spaces?
  validate :correct_length_with_converted_emoji?

  private

  # soll verhindern, das man z.B. einfach 200 Zeichen lang a drückt und das Layout zerschiesst
  def correct_spaces?
    unless text.present? &&
        ((text.size > MAX_SIZE_WITHOUT_SPACES && text.include?(" ")) ||
            text.size <= MAX_SIZE_WITHOUT_SPACES)

      errors.add(:base, I18n.t(:notice_needs_spaces))
    end
  end

  # only check if normal text is not too long
  def correct_length_with_converted_emoji?
    if text.size <= MAX_SIZE
      text_with_converted_emojis = ::Emojimmy.emoji_to_token(text)

      if text_with_converted_emojis.size > MAX_SIZE
        errors.add(:base, I18n.t(:notice_to_long_with_emojis))
      end
    end
  end

end
