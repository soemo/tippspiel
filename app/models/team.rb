class Team < ActiveRecord::Base

  validates_presence_of :flag_image_url
  validates_presence_of :name

end
