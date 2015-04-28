# -*- encoding : utf-8 -*-
module TippsHelper

  def get_today_game_css_class(today_game_ids, game_id)
    result = ''
    if today_game_ids.present? && game_id.present?
      result = Array(today_game_ids).include?(game_id) ? 'today_game' : ''
    end

    result
  end

  def write_tipp_input(tipp_id, attr_name, attr_value)
    haml_concat text_field_tag( "tipps[#{tipp_id}][#{attr_name}]", attr_value, :maxlength => 2, :size => 2, :class => 'tipp_input')
  end

end
