# -*- encoding : utf-8 -*-
class Notice < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :user

  validates_presence_of :text
  validates_length_of :text, :maximum => 200
  validates_presence_of :user

  default_scope order("created_at desc")

  def self.last_updated
    Notice.unscoped.order('updated_at desc').first
  end

  # ich will verhindern, das mann einfach 200 Zeichen lang a drückt und das Layout zerschiesst
  def correct_spaces?(max_size_without_spaces=30)
    text.present? && ((text.size > max_size_without_spaces && text.include?(" ")) || text.size <= max_size_without_spaces)
  end

end
