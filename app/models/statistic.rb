class Statistic < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :user
 # belongs_to :starttime ## FIXME soeren 24.11.11 war mal day

  validates_presence_of :user
#  validates_presence_of :starttime
  validates_presence_of :position

end
