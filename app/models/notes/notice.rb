# -*- encoding : utf-8 -*-
class Notice < ActiveRecord::Base
  acts_as_paranoid

  MAX_SIZE = 200
  MAX_SIZE_WITHOUT_SPACES = 100

  belongs_to :user

  validates_presence_of :text
  validates_length_of :text, :maximum => MAX_SIZE
  validates_presence_of :user

end
