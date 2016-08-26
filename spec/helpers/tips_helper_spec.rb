require 'rails_helper'

describe TipsHelper, :type => :helper do

  context '#write_tip_input' do

    it 'returns corrct input html' do
      expect(helper.tip_input(1, 'team1_goals', 2)).to eq("<input type=\"number\" name=\"tips[1][team1_goals]\" id=\"tips_1_team1_goals\" value=\"2\" maxlength=\"2\" size=\"2\" class=\"tip_input\" pattern=\"[0-9]{1,2}\" />")
    end
  end

end
