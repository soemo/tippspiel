# -*- encoding : utf-8 -*-
module Tips
  class FromUser < BaseService

    attribute :user_id, Integer

    def call
      user_tips
    end

    private

    def user_tips
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

    def tips_with_games
      if user_id.present?
        ::Tip.includes(:game).where("user_id" => user_id)
      else
        []
      end
    end

    def create_user_tips
      game_ids = ::Game.pluck(:id)
      if game_ids.present?

        # https://www.coffeepowered.net/2009/01/23/mass-inserting-data-in-rails-without-killing-your-performance/
        values = []
        time = Time.current.to_s(:db)

        game_ids.each do |game_id|
          values.push("(#{user_id}, #{game_id}, '#{time}', '#{time}')")
        end
        # FIXME soeren 12.10.15 in TipQueries verlagern
        sql = "INSERT INTO tips (user_id, game_id, created_at, updated_at) VALUES #{values.join(', ')}"
        ::Tip.connection.execute(sql)
      end
    end

  end
end