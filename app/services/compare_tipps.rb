# -*- encoding : utf-8 -*-
class CompareTipps < BaseService

  attribute :game_id, Integer

  Result = Struct.new(:posssible_games, :game_to_compare, :tipps)

  def call
    compare_tipps
  end

  private

  def compare_tipps
    posssible_games = Game.games_for_compare(Time.now)
    game_to_compare = nil
    tipps           = nil

    if game_id.present? && posssible_games.present? && posssible_games.pluck(:id).include?(game_id)
      game_to_compare = posssible_games.where(id: game_id).first
    elsif posssible_games.present?
      game_to_compare = posssible_games.last
    end #no else

    if game_to_compare.present?
      tipps = game_to_compare.
          tipps.
          includes('user').
          where('users.deleted_at' => nil).
          order('tipps.tipp_punkte desc').
          order('users.firstname')
    end

    Result.new(posssible_games, game_to_compare, tipps)
  end

  def possible_games
    Game.games_for_compare(Time.now).all
  end

end