class Tipp < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :game
  belongs_to :user

  validates_presence_of :user
  validates_presence_of :game
  validates_presence_of :team1_tore, :unless => lambda{ |object| object.new_record? }
  validates_presence_of :team2_tore, :unless => lambda{ |object| object.new_record? }
  validates_numericality_of :team1_tore, :allow_nil => true, :on => :update, :greater_than_or_equal_to => 0
  validates_numericality_of :team2_tore, :allow_nil => true, :on => :update, :greater_than_or_equal_to => 0

  def edit_allowed
    game.start_at > Time.now
  end

  def self.user_tipps(user_id)
    result = []
    if user_id.present?
      result = Tipp.tipps_with_games(user_id)
      unless result.present?
        Tipp.create_user_tipps(user_id)
        result = Tipp.tipps_with_games(user_id)
      end
    end

    result
  end

  def remove_leading_zero
    if team1_tore.present?
      self.team1_tore = team1_tore.to_i
    end
    if team2_tore.present?
      self.team2_tore = team2_tore.to_i
    end
  end

  private
  def self.tipps_with_games(user_id)
    if user_id.present?
      Tipp.includes(:game).where("user_id" => user_id)
    else
      []
    end
  end

  def self.create_user_tipps(user_id)
    games = Game.all
    if games.present?
      games.each do |game|
        Tipp.create!(:user_id => user_id, :game_id => game.id)
      end
    end
  end

end
