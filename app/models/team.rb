class Team < ActiveRecord::Base
  acts_as_paranoid

  ## FIXME soeren 24.11.11 needs flag validates_presence_of :flag_image_url
  validates_presence_of :name

  def to_s
    if name == "Deutschland"
      "<b>".html_safe+name+"</b>".html_safe
    else
      name
    end
  end

end
