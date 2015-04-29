# -*- encoding : utf-8 -*-
require 'rails_helper'

describe ApplicationHelper, :type => :helper do

  context  '#is_selected_controller?' do

    context "when controller is HallOfFame" do
      before :each do
        expect(helper).to receive(:controller).and_return(HallOfFamesController)
      end

      it 'returns true if link name is hall-of-fame' do
        expect(helper.is_selected_controller?('hall-of-fame')).to be true
      end
      it 'returns true if link name is hall-of-fames' do
        expect(helper.is_selected_controller?('hall-of-fames')).to be true
      end
      it 'returns true if link name is hall_of_fame' do
        expect(helper.is_selected_controller?('hall_of_fame')).to be true
      end
      it 'returns true if link name is hall_of_fames' do
        expect(helper.is_selected_controller?('hall_of_fames')).to be true
      end

      it 'returns false, if it is another link name' do
        expect(helper.is_selected_controller?('help')).to be false
        expect(helper.is_selected_controller?('')).to be false
        expect(helper.is_selected_controller?(nil)).to be false
      end
    end

  end

end
