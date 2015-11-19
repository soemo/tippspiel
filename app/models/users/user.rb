# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :championtip_team, :class_name => "Team"
  has_many   :tips, :dependent => :destroy

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

  # Braucht ein Nutzer laenger als diese Zeit, um den Confirmation-Link aufzurufen,
  # ist das Token ungueltig
  CONFIRMATION_MAX_TIME = 7.day

  scope :active,   -> { where('confirmed_at is not null') }
  scope :inactive, -> { where('confirmed_at is null') }

  def ranking_comparison_value
    str_points       = points.to_s.rjust(2,"0")
    str_count8points = count8points.to_s.rjust(2,"0")
    str_count5points = count5points.to_s.rjust(2,"0")
    str_count4points = count4points.to_s.rjust(2,"0")
    str_count3points = count3points.to_s.rjust(2,"0")
    "#{str_points}#{str_count8points}#{str_count5points}#{str_count4points}#{str_count3points}".to_i
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
    (firstname + ' ' + lastname) rescue email
  end

  def admin?
    self.email == ADMIN_EMAIL
  end

  # TODO soeren 30.04.15 move to new service
  # liefert im Fehlerfall ein Array von Error-Meldungen zurueck
  def valid_password_change_params(old_password, password, password_confirmation)
    error_messages = []

    unless self.valid_password?(old_password)
      error_messages << I18n.t(:change_password_wrong_old_pw)
    end
    if password.blank? || password_confirmation.blank? || old_password.blank?
      error_messages << I18n.t(:change_password_need_all_input_fields)
    end
    if password.present? && password_confirmation.present? && password != password_confirmation
      error_messages << I18n.t(:change_password_wrong_pw_confirmation)
    end

    error_messages
  end

  protected

  # Checks whether a password is needed or not. For validations only.
  # Passwords are always required if it's a new record, or if the password
  # or confirmation are being set somewhere. from Devise
  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end


end
