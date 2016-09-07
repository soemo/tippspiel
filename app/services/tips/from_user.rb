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

        game_ids.each do |game_id|
          values.push("(#{user_id}, #{game_id}, '#{time}', '#{time}')")
        end
        sql = "INSERT INTO tips (user_id, game_id, created_at, updated_at) VALUES #{values.join(', ')}"
        ::Tip.connection.execute(sql)
      end
    end

  end
end