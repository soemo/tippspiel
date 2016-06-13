# -*- encoding : utf-8 -*-
class Team < ActiveRecord::Base
  acts_as_paranoid

  validates_presence_of :name

end
