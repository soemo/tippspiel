class Notice < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :user

  validates_presence_of :name
  validates_presence_of :user
end
