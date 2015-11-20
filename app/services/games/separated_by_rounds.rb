# -*- encoding : utf-8 -*-
module Games
  class SeparatedByRounds < BaseService

    def call
      separated_by_rounds
    end


    private

    def separated_by_rounds
      result = {}
      group_size = GROUPS.size
      GROUPS.each_with_index do |group_name, index|
        # FIXME soeren 20.11.15 neue komplette Query
        games = ::GameQueries.group_games_ordered_by_start_at.where(group: group_name).to_a
        result[index + 1] = {"#{GROUP}_#{group_name}".downcase => games}
      end
      (ROUNDS - [GROUP]).each_with_index do |round, index|
        result[group_size + index + 1] = {round => GameQueries.all_by_round(round).to_a}
      end

      result.sort
    end

  end
end