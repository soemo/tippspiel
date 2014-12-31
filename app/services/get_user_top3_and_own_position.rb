# -*- encoding : utf-8 -*-
class GetUserTop3AndOwnPosition < BaseService

  attribute :user_id, Integer

  def call
    top3_and_own_position
  end

  private

  def top3_and_own_position
    result = {}
    own_position = nil

    user_ranking_hash = PrepareUserRanking.call
    if user_ranking_hash.present?
      3.times do |i|
        counter = i + 1
        result[counter] = user_ranking_hash[counter] if user_ranking_hash.has_key?(counter)
      end
      if user_id.present?
        user_ranking_hash.each_pair do |k,v|
          own_position = k if v.map(&:id).include?(user_id)
        end
      end
    end

    [result, own_position]
  end


end