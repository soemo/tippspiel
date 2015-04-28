# -*- encoding : utf-8 -*-
module Tipps
  class Compare < BaseService

    attribute :game_id, Integer

    Result = Struct.new(:possible_games, :game_to_compare, :tipps)

    def call
      compare
    end


    private

    def compare
      possible_games = get_possible_games
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

    def get_possible_games
      Game.where('start_at < ?', Time.now)
    end

  end
end