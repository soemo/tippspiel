# -*- encoding : utf-8 -*-
class CompareTipps < BaseService
  # FIXME soeren 01.02.15 spec
  attribute :game_id, Integer

  Result = Struct.new(:possible_games, :game_to_compare, :tipps)

  def call
    compare_tipps
  end

  private

  def compare_tipps
    possible_games = Game.games_for_compare(Time.now)
    game_to_compare = nil
    tipps           = nil

    if game_id.present? && possible_games.present? && possible_games.pluck(:id).include?(game_id)
      game_to_compare = possible_games.where(id: game_id).first
    elsif possible_games.present?
      game_to_compare = possible_games.last
    end #no else

    if game_to_compare.present?
      tipps = game_to_compare.
          tipps.
          includes('user').
          where('users.deleted_at' => nil).
          order('tipps.tipp_punkte desc').
          order('users.firstname')
    end

    Result.new(possible_games, game_to_compare, tipps)
  end

  def possible_games
    Game.games_for_compare(Time.now).all
  end

end