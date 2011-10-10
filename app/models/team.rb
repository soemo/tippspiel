class Team < ActiveRecord::Base
  acts_as_paranoid

  validates_presence_of :flag_image_url
  validates_presence_of :name

end
