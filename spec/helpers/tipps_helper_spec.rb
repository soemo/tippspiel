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

  context '#prepare_tipps' do
    # FIXME soeren 28.04.15
  end

  context '#write_tipp_input' do
    # FIXME soeren 28.04.15
  end

end
