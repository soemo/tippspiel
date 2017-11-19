class User < ApplicationRecord
  acts_as_paranoid

  belongs_to :championtip_team, class_name: 'Team', optional: true
  has_many   :tips, dependent: :destroy

  validates               :email, :presence => true
  validates_uniqueness_of :email, :allow_blank => true, :scope => :deleted_at, :case_sensitive => false, :if => :email_changed?
  validates_format_of     :email, :with  => Devise.email_regexp, :allow_blank => true
  validates               :firstname, :presence => true
  validates               :lastname, :presence => true

  validates_presence_of     :password, if: :password_required?
  validates_confirmation_of :password, if: :password_required?
  validates_length_of       :password, within: Devise.password_length, allow_blank: true


  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable , :reconfirmable and :timeoutable
  devise :database_authenticatable, :confirmable, :registerable, :recoverable, :rememberable, :trackable

  scope :active,   -> { where('confirmed_at is not null') }
  scope :inactive, -> { where('confirmed_at is null') }

  def name
    "#{firstname} #{lastname}"
  end

  def admin?
    self.email == ADMIN_EMAIL
  end

  protected

  # Checks whether a password is needed or not. For validations only.
  # Passwords are always required if it's a new record, or if the password
  # or confirmation are being set somewhere. from Devise
  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
end
