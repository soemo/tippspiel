# -*- encoding : utf-8 -*-
class Poll < ActiveRecord::Base
  acts_as_paranoid

  validates_presence_of :name

  # FIXME soeren 20.05.13 Umfrage nutzen oder komplett entfernen

end
