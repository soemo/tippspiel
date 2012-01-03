class User < ActiveRecord::Base
  acts_as_paranoid
  validates_as_paranoid

  belongs_to :championtipp_team, :class_name => "Team"
  belongs_to :poll

  validates                               :email,   :presence => true
  validates_uniqueness_of_without_deleted :email,   :scope => Devise.authentication_keys[1..-1], :case_sensitive => false, :allow_blank => true
  validates_format_of                     :email,   :with  => Devise.email_regexp, :allow_blank => true
  validates                               :firstname, :presence => true
  validates                               :lastname, :presence => true


  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :lastname, :firstname

  # Braucht ein Nutzer laenger als diese Zeit, um den Confirmation-Link aufzurufen,
  # ist das Token ungueltig
  CONFIRMATION_MAX_TIME = 7.day

  scope :ranking_order, order("users.points DESC, users.count6points DESC, users.count4points DESC, users.count3points DESC")

  def ranking_comparison_value
    "#{points}#{count6points}#{count4points}#{count3points}".to_i
  end

  def confirm_with_maximum_time!
    if self.confirmation_sent_at.present? && (self.confirmation_sent_at < CONFIRMATION_MAX_TIME.ago)
      self.errors.add(:base, :too_late)
    else
      confirm_without_maximum_time!
    end
  end
  alias_method_chain(:confirm!, :maximum_time)

  def to_s
    name
  end

  def name
    (firstname + " " + lastname) rescue email
  end

end
