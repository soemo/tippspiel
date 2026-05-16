class User < ApplicationRecord
  acts_as_paranoid

  belongs_to :bonus_champion_team, class_name: 'Team', optional: true
  belongs_to :bonus_second_team, class_name: 'Team', optional: true
  has_many   :tips, dependent: :destroy

  validates               :email, :presence => true
  validates_uniqueness_of :email, :allow_blank => true, :scope => :deleted_at, :case_sensitive => false, :if => :email_changed?
  validates_format_of     :email, :with  => Devise.email_regexp, :allow_blank => true
  validates_confirmation_of :email, if: :email_confirmation_required?
  validates               :firstname, :presence => true
  validates               :lastname, :presence => true
  validate :name_fields_must_not_contain_email

  validates_presence_of     :password, if: :password_required?
  validates_confirmation_of :password, if: :password_required?
  validates_length_of       :password, within: Devise.password_length, allow_blank: true


  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable , :reconfirmable and :timeoutable
  devise :database_authenticatable, :confirmable, :registerable, :recoverable, :rememberable, :trackable

  scope :active,   -> { where('confirmed_at is not null') }
  scope :inactive, -> { where('confirmed_at is null') }

  def admin?
    self.email == ADMIN_EMAIL
  end

  def all_bonus_questions_filled_out?
    bonus_champion_team_id.present? &&
      bonus_second_team_id.present? &&
      bonus_when_final_first_goal.present? &&
      bonus_how_many_goals.present?
  end

  def name
    "#{firstname} #{lastname}"
  end

  protected

  # Checks whether a password is needed or not. For validations only.
  # Passwords are always required if it's a new record, or if the password
  # or confirmation are being set somewhere. from Devise
  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  # Email confirmation is only required on new registrations or when the email is being changed.
  def email_confirmation_required?
    !persisted? || email_changed?
  end

  def name_fields_must_not_contain_email
    email_pattern = Devise.email_regexp
    if firstname.present? && firstname.match?(email_pattern)
      errors.add(:firstname, :must_not_contain_email)
    end
    if lastname.present? && lastname.match?(email_pattern)
      errors.add(:lastname, :must_not_contain_email)
    end
  end
end
