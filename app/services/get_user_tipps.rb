# -*- encoding : utf-8 -*-
class GetUserTipps

  include BaseService
  include Virtus.model

  attribute :user_id, Integer

  def call
    user_tipps
  end

  private

  def user_tipps
    result = []

    if user_id.present?
      # FIXME soeren 17.09.2014 geht das nicht besser find_or_create ???
      result = tipps_with_games
      unless result.present?
        create_user_tipps
        result = tipps_with_games
      end
    end

    result
  end

  def tipps_with_games
    if user_id.present?
      Tipp.includes(:game).where("user_id" => user_id)
    else
      []
    end
  end

  def create_user_tipps
    game_ids = Game.pluck(:id)
    if game_ids.present?
      game_ids.each do |game_id|
        Tipp.create!(:user_id => user_id, :game_id => game_id)
      end
    end
  end

end