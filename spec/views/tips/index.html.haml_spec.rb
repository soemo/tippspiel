# -*- encoding : utf-8 -*-
require 'rails_helper'

describe 'tips/index.html.haml', :type => :view do

  let(:user) {create(:active_user)}

  let(:presenter) {TipsIndexPresenter.new([Tip.new(game: Game.new(start_at: Time.now - 1.minute)),
                                           Tip.new(game: Game.new(start_at: Time.now - 1.minute))],
                                          user)}

  context 'when tournament is not started' do

    before :each do
      allow(Tournament).to receive(:started?).and_return(false)
    end

    it 'shows info to select champion' do
      assign(:presenter, presenter)

      render

      expect(rendered).to have_selector('h3', :text => I18n.t('your_tips'))
      expect(rendered).to have_selector('b', :text => I18n.t('need_champion_tip'))
      expect(rendered).to have_content(I18n.t('need_champion_tip_info', :points => Users::UpdatePoints::CHAMPION_TIP_POINTS))

      expect(rendered).to have_xpath("//form[@action='/save-champion-tip']") do |form|
        expect(form).to have_selector('label', :text => I18n.t('who_will_be_champion'))
      end
    end

  end

  context 'when tournament is started' do
    before :each do
      allow(Tournament).to receive(:started?).and_return(true)
    end

    it 'should say no champion tip' do
      assign(:presenter, presenter)

      render

      expect(rendered).to have_selector('h3', :text => I18n.t('your_tips'))
      expect(rendered).to have_content(I18n.t('no_champion_tip'))

    end
  end

end
