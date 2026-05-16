class Notice < ApplicationRecord
  acts_as_paranoid

  MAX_SIZE = 200
  MAX_SIZE_WITHOUT_SPACES = 100

  belongs_to :user

  validates_presence_of :text
  validates_length_of :text, :maximum => MAX_SIZE
  validates_presence_of :user

  validate :correct_spaces?

  private

  # soll verhindern, das man z.B. einfach 200 Zeichen lang a drückt und das Layout zerschiesst
  def correct_spaces?
    unless text.present? &&
        ((text.size > MAX_SIZE_WITHOUT_SPACES && text.include?(" ")) ||
            text.size <= MAX_SIZE_WITHOUT_SPACES)

      errors.add(:base, I18n.t(:notice_needs_spaces))
    end
  end

end
