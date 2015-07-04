# -*- encoding : utf-8 -*-
module Tips
  class SeparatedByRounds < BaseService

    attribute :tips, Array

    def call
      separated_by_rounds
    end


    private

    def separated_by_rounds
      result = {}
      if tips.present?
        games_round_hash = Games::SeparatedByRounds.call
        games_round_hash.each do |index, round_with_games|
          round_with_games.each_pair do |round_name, games|
            temp_tips = []
            games.each do |game|
              tip = tips.select{|t| t.game_id == game.id}
              temp_tips << tip.first
            end
            result[index] = {round_name => temp_tips}
          end
        end
      end

      result.sort
    end

  end
end