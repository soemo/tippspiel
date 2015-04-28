# -*- encoding : utf-8 -*-
require 'rails_helper'

describe TippsHelper, :type => :helper do

  context '#get_today_game_css_class' do

    context 'when today_game_id and game_id present?' do

      it "returns today_game css class" do
        expect(get_today_game_css_class([1,2,3], 1)).to eq('today_game')
        expect(get_today_game_css_class(1, 1)).to eq('today_game')
      end

      it "returns empty today_game css class if game_id not in today_game_ids" do
        expect(get_today_game_css_class([1,2,3], 6)).to eq('')
      end
    end

    context 'when today_game_id or/and game_id not present?' do

      it "returns empty today_game css class" do
        expect(get_today_game_css_class([], 1)).to eq('')
        expect(get_today_game_css_class([1], nil)).to eq('')
        expect(get_today_game_css_class([nil], nil)).to eq('')
        expect(get_today_game_css_class([nil], 1)).to eq('')
        expect(get_today_game_css_class(nil, nil)).to eq('')
      end

    end
  end

  context '#write_tipp_input' do

    it 'returns corrct input html' do
      helper.extend Haml
      helper.extend Haml::Helpers
      helper.send :init_haml_helpers

      value = helper.capture_haml{
        expect(helper.write_tipp_input(1, 'team1_goals', 2))
      }
      expect(value).to eq("<input type=\"text\" name=\"tipps[1][team1_goals]\" id=\"tipps_1_team1_goals\" value=\"2\" maxlength=\"2\" size=\"2\" class=\"tipp_input\" />\n")

    end
  end

end
