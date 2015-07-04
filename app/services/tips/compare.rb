# -*- encoding : utf-8 -*-
module Tips
  class Compare < BaseService

    attribute :game_id, Integer

    Result = Struct.new(:possible_games, :game_to_compare, :tips)

    def call
      compare
    end


    private

    def compare
      possible_games = GameQueries.started_games
      game_to_compare = nil
      tips           = nil

      if game_id.present? && possible_games.present? && possible_games.pluck(:id).include?(game_id)
        game_to_compare = possible_games.where(id: game_id).first
      elsif possible_games.present?
        game_to_compare = possible_games.last
      end #no else

      if game_to_compare.present?
        tips = ::TipQueries.get_ordered_tips_for_game_id(game_to_compare.id)
      end

      Result.new(possible_games, game_to_compare, tips)
    end

  end
end