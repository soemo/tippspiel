# -*- encoding : utf-8 -*-
require 'rails_helper'

describe RankingHelper, :type => :helper do
  it 'should get statistik_tooltip' do
    user = FactoryGirl.build(:user, :points => 13,
                                    :championtipppoints => 0,
                                    :count8points => 1,
                                    :count5points => 2,
                                    :count4points => 1,
                                    :count3points => 1,
                                    :count0points => 5)

    expect(statistik_tooltip(user)).to eq("<b>Punkteverteilung</b></br>1 x 8 Punkte</br>2 x 5 Punkte</br>1 x 4 Punkte</br>1 x 3 Punkte</br>5 x 0 Punkte</br>Punkte Siegertipp: 0")

  end
end
