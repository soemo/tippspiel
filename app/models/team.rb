# -*- encoding : utf-8 -*-
class Team < ActiveRecord::Base
  acts_as_paranoid

  validates_presence_of :name

  def self.last_updated_at
    Team.unscoped.maximum('updated_at')
  end

  def to_s
    name
  end

end
