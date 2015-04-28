# -*- encoding : utf-8 -*-
module Tipps
  class SeparatedByRounds < BaseService

    attribute :tipps, Array

    def call
      separated_by_rounds
    end


    private

    def separated_by_rounds
      result = {}
      if tipps.present?
        games_round_hash = Games::SeparatedByRounds.call
        games_round_hash.each do |index, round_with_games|
          round_with_games.each_pair do |round_name, games|
            temp_tipps = []
            games.each do |game|
              tipp = tipps.select{|t| t.game_id == game.id}
              temp_tipps << tipp.first
            end
            result[index] = {round_name => temp_tipps}
          end
        end
      end

      result.sort
    end

  end
end