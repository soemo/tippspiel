require 'rails_helper'

describe 'bonus/edit.html.haml', :type => :view do

  let!(:user) {create_active_user}
  let!(:presenter) {BonusEditPresenter.new(user)}

  before :each do
    allow(view).to receive(:current_user).and_return(user)
  end

  context 'when tournament ROUND_OF_16 is not started' do

    before :each do
      allow(Tournament).to receive(:round_of_16_not_yet_started?).and_return(true)
    end

    it 'shows info to select champion' do
      assign(:presenter, presenter)

      render

      expect(rendered).to have_selector('h3', :text => I18n.t('your_bonustips'))

      expect(rendered).to have_xpath("//form[@action='/bonus_tips']") do |form|
        #todo soeren expect(form).to have_selector('label', :text => I18n.t('who_will_be_champion'))
      end
    end

  end

  context 'when tournament ROUND_OF_16 is started' do
    before :each do
      allow(Tournament).to receive(:round_of_16_not_yet_started?).and_return(false)
    end

    it 'should say no champion tip' do
      assign(:presenter, presenter)

      render

      expect(rendered).to have_selector('h3', :text => I18n.t('your_bonustips'))
      expect(rendered).to have_content(I18n.t('no_champion_tip'))

    end
  end
end
