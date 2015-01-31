# -*- encoding : utf-8 -*-
class GetUserTop3AndOwnPosition < BaseService

  attribute :user_id, Integer

  Result = Struct.new(:user_top3_ranking_hash, :own_position)

  def call
    top3_and_own_position
  end

  private

  def top3_and_own_position
    user_top3_ranking_hash = {}
    own_position = nil

    user_ranking_hash = PrepareUserRanking.call
    if user_ranking_hash.present?
      3.times do |i|
        counter = i + 1
        user_top3_ranking_hash[counter] = user_ranking_hash[counter] if user_ranking_hash.has_key?(counter)
      end
      if user_id.present?
        user_ranking_hash.each_pair do |k,v|
          own_position = k if v.map(&:id).include?(user_id)
        end
      end
    end

    Result.new(user_top3_ranking_hash, own_position)
  end


end