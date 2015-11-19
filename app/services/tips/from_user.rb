# -*- encoding : utf-8 -*-
module Tips
  class FromUser < BaseService

    attribute :user_id, Integer

    def call
      result = []

      if user_id.present?
        result = tips_with_games
        unless result.present?
          create_user_tips
          result = tips_with_games
        end
      end

      result
    end


    private

    def tips_with_games
      ::TipQueries.all_by_user_id_with_preloaded_games(user_id)
    end

    def create_user_tips
      game_ids = ::GameQueries.all_game_ids
      if game_ids.present?

        # https://www.coffeepowered.net/2009/01/23/mass-inserting-data-in-rails-without-killing-your-performance/
        values = []
        time = Time.current.to_s(:db)

        game_ids.each do |game_id|
          values.push("(#{user_id}, #{game_id}, '#{time}', '#{time}')")
        end
        sql = "INSERT INTO tips (user_id, game_id, created_at, updated_at) VALUES #{values.join(', ')}"
        ::Tip.connection.execute(sql)
      end
    end

  end
end