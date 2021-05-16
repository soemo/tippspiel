module Tips
  class FromUser < BaseService

    attribute :user_id, Integer

    def call
      result = []

      if user_id.present?
        create_user_tips unless ::TipQueries.exists_for_user_id(user_id)
        result = ::TipQueries.all_by_user_id_ordered_games_start_at(user_id)
      end

      result
    end

    private

    def create_user_tips
      game_ids = ::GameQueries.all_game_ids
      if game_ids.present?

        # https://www.coffeepowered.net/2009/01/23/mass-inserting-data-in-rails-without-killing-your-performance/
        values = []
        time = Time.current.to_s(:db)
        needs_random_tips = ::UserQueries.needs_random_tips_for_user_id?(user_id)

        game_ids.each do |game_id|
          if needs_random_tips
            values.push("(#{user_id}, #{game_id}, '#{time}', '#{time}', #{rand(5)}, #{rand(5)})")
          else
            values.push("(#{user_id}, #{game_id}, '#{time}', '#{time}')")
          end

        end

        if needs_random_tips
          sql = "INSERT INTO tips (user_id, game_id, created_at, updated_at, team1_goals, team2_goals) VALUES #{values.join(', ')}"
        else
          sql = "INSERT INTO tips (user_id, game_id, created_at, updated_at) VALUES #{values.join(', ')}"
        end

        ::Tip.connection.execute(sql)
      end
    end

  end
end