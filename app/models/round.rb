class Round < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :start_day, :class_name => "Day"
  belongs_to :end_day, :class_name => "Day"

  validates_presence_of :name
  validates_presence_of :start_day
  validates_presence_of :end_day

end
