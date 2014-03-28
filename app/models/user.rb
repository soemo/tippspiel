# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  acts_as_paranoid
  validates_as_paranoid

  belongs_to :championtipp_team, :class_name => "Team"
  belongs_to :poll,  :dependent => :destroy
  has_many  :tipps, :dependent => :destroy

  validates                               :email,   :presence => true
  validates_uniqueness_of_without_deleted :email,   :scope => Devise.authentication_keys[1..-1], :case_sensitive => false, :allow_blank => true
  validates_format_of                     :email,   :with  => Devise.email_regexp, :allow_blank => true
  validates                               :firstname, :presence => true
  validates                               :lastname, :presence => true


  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable , :reconfirmable and :timeoutable
  devise :database_authenticatable, :confirmable, :registerable, :recoverable, :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :lastname, :firstname

  # Braucht ein Nutzer laenger als diese Zeit, um den Confirmation-Link aufzurufen,
  # ist das Token ungueltig
  CONFIRMATION_MAX_TIME = 7.day

  scope :active, where('confirmed_at is not null')
  scope :inactive, where('confirmed_at is null')

  scope :ranking_order, order('users.points DESC, users.count8points DESC, users.count5points DESC, users.count4points DESC, users.count3points DESC')

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

  def has_champion_tipp?
    championtipp_team_id.present?
  end

  def admin?
    self.email == ADMIN_EMAIL
  end

  # bekommt eine Liste von Usern,
  # sortiert nach Gesamtpunkten, Anzahl6Punkte, Anzahl4Punkte und Anzahl3Punkte geliefert
  # Es wird noch die Platzierung als Key hinzugefuegt
  # (wenn 3 Leute erster sind, ist der nächste dann auf Platz 4)
  # ACHTUNG DER HASH IST NICHT SORTIERT !!!!
  def self.prepare_user_ranking(ranking_users=User.active.ranking_order)
    result = {}
    if ranking_users.present?
      place                    = 1
      user_count_on_same_place = 1
      last_used_user           = nil

      ranking_users.each do |u|
        if last_used_user.nil?
          # erste User
          result[place] = [u]
        else
          if last_used_user.ranking_comparison_value > u.ranking_comparison_value
            place = place + user_count_on_same_place
            result[place] = [u]
            user_count_on_same_place = 1
          elsif last_used_user.ranking_comparison_value == u.ranking_comparison_value
            same_place_users = result[place]
            result[place] = same_place_users + [u]
            user_count_on_same_place = user_count_on_same_place + 1
          else
            # no else
          end
        end
        last_used_user = u
      end
    end

    result
  end

  def self.top3_positions_and_own_position(own_user_id=nil)
    result = {}
    own_position = nil

    user_ranking_hash = User.prepare_user_ranking
    if user_ranking_hash.present?
      3.times do |i|
        counter = i + 1
        result[counter] = user_ranking_hash[counter] if user_ranking_hash.has_key?(counter)
      end
      if own_user_id.present?
        user_ranking_hash.each_pair do |k,v|
          own_position = k if v.map(&:id).include?(own_user_id)
        end
      end
    end

    [result, own_position]
  end

end
