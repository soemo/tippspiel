# -*- encoding : utf-8 -*-
module Games
  class SeparatedByRounds < BaseService

    def call
      separated_by_rounds
    end


    private

    def separated_by_rounds
      result = {}
      group_size = Game::GROUPS.size
      Game::GROUPS.each_with_index do |group_name, index|
        result[index + 1] = {"#{Game::GROUP}_#{group_name}".downcase => Game.group_games.where(:group => group_name).to_a}
      end
      (Game::ROUNDS - [Game::GROUP]).each_with_index do |round, index|
        result[group_size + index + 1] = {round => Game.where(:round => round).to_a}
      end

      result.sort
    end

  end
end