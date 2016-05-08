# -*- encoding : utf-8 -*-
require 'rails_helper'

describe ApplicationHelper, :type => :helper do

  describe '#filter_categories_options' do

    it 'returns mixitup filter buuton options' do
      expect(helper.filter_categories_options).to eq(
                                                      [{:label=>"Alle Spiele",
                                                        :class=>"filter button active",
                                                        :data_filter=>"all"},
                                                       {:label=>"Heutige Spiele",
                                                        :class=>"filter button",
                                                        :data_filter=>".category-today"},
                                                       {:label=>"Ausstehende Spiele",
                                                        :class=>"filter button",
                                                        :data_filter=>".category-future"}]
                                                  )
    end
  end
end
