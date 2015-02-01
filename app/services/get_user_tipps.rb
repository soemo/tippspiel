# -*- encoding : utf-8 -*-
class GetUserTipps < BaseService

  attribute :user_id, Integer

  def call
    user_tipps
  end

  private

  def user_tipps
    result = []

    if user_id.present?
      # FIXME soeren 17.09.2014 geht das nicht besser find_or_create ???
      result = tipps_with_games
      unless result.present?
        create_user_tipps
        result = tipps_with_games
      end
    end

    result
  end

  def tipps_with_games
    if user_id.present?
      Tipp.includes(:game).where("user_id" => user_id)
    else
      []
    end
  end

  def create_user_tipps
    game_ids = Game.pluck(:id)
    if game_ids.present?

      # https://www.coffeepowered.net/2009/01/23/mass-inserting-data-in-rails-without-killing-your-performance/
      values = []
      time = Time.current.to_s(:db)

      game_ids.each do |game_id|
        values.push("(#{user_id}, #{game_id}, '#{time}', '#{time}')")
      end

      sql = "INSERT INTO tipps (user_id, game_id, created_at, updated_at) VALUES #{values.join(', ')}"
      Tipp.connection.execute(sql)
    end
  end

end