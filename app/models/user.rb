class User < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :championtipp_team, :class_name => "Team"
  belongs_to :poll

  # TODO soeren 09.10.11 oder macht das device
  validates_presence_of :email
  # TODO soeren 09.10.11 validates_format_of :email oder macht das device
  validates_presence_of :firstname
  validates_presence_of :lastname


  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  # Braucht ein Nutzer laenger als diese Zeit, um den Confirmation-Link aufzurufen,
  # ist das Token ungueltig
  CONFIRMATION_MAX_TIME = 7.day

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
