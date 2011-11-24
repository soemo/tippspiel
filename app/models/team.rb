class Team < ActiveRecord::Base
  acts_as_paranoid

  ## FIXME soeren 24.11.11 needs flag validates_presence_of :flag_image_url
  validates_presence_of :name

  def to_s
    name
  end

end
