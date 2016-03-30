# -*- encoding : utf-8 -*-
module TipsHelper

  def tip_input(tip_id, attr_name, attr_value)
    name = "tips[#{tip_id}][#{attr_name}]"
    text_field_tag(name, attr_value, maxlength: 2, size: 2, class: 'tip_input')
  end
end
