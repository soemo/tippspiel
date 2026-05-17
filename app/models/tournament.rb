# frozen_string_literal: true

# Poro
class Tournament
  def self.started?
    result = false
    first_game = GameQueries.first_game_in_tournament
    result = true if first_game.present? && first_game.start_at < Time.zone.now
    result
  end

  def self.round_of_16_not_yet_started?
    !Tournament.round_of_16_started?
  end

  def self.round_of_32_started?
    start_date_time, _end_date_time = Tournament.round_start_end_date_time(ROUND_OF_32)
    start_date_time.present? && start_date_time < Time.zone.now
  end

  def self.round_of_32_not_yet_started?
    !Tournament.round_of_32_started?
  end

  # is true, if the final game is marked as finished
  def self.finished?
    result = false
    final_game = GameQueries.final_game
    result = final_game.finished? if final_game.present?

    result
  end

  def self.round_of_16_started?
    start_date_time, _end_date_time = Tournament.round_start_end_date_time(ROUND_OF_16)
    start_date_time.present? && start_date_time < Time.zone.now
  end

  def self.round_start_end_date_time(round)
    ordered_started_at_asc = GameQueries.ordered_started_at_for(round)
    if ordered_started_at_asc.present?
      start_date_time = ordered_started_at_asc.first
      end_date_time   = ordered_started_at_asc.last
    else
      start_date_time = end_date_time = nil
    end

    [start_date_time, end_date_time]
  end
end
