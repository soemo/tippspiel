# -*- encoding : utf-8 -*-
module TippsHelper

  # Die Tipps werden so aufbereitet, das sie nach den Runden sortiert sind
  def prepare_tipps(user_tipps)
    result = {}
    if user_tipps.present?
      games_round_hash = Game.splited_by_rounds
      games_round_hash.each do |index, round_with_games|
        round_with_games.each_pair do |round_name, games|
          temp_tipps = []
          games.each do |game|
            tipp = user_tipps.select{|tipp| tipp.game_id == game.id}
            temp_tipps << tipp.first
          end
          result[index] = {round_name => temp_tipps}
        end
      end
    end

    result.sort
  end

  def get_today_game_css_class(today_game_ids, game_id)
    result = ''
    if today_game_ids.present? && game_id.present?
      result = today_game_ids.include?(game_id) ? 'today_game' : ''
    end

    result
  end

  def write_tipp_input(tipp_id, attr_name, attr_value)
    haml_concat text_field_tag( "tipps[#{tipp_id}][#{attr_name}]", attr_value, :maxlength => 2, :size => 2, :class => 'tipp_input')
  end

end
