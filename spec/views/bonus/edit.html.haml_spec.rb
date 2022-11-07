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

      expect(rendered).to have_xpath("//form[@action='/bonus_tips']")
      expect(rendered).to have_xpath("//select[@id='bonus_champion_team_id']")
      expect(rendered).to have_xpath("//select[@id='bonus_second_team_id']")
      expect(rendered).to have_xpath("//select[@id='bonus_when_final_first_goal']")
      expect(rendered).to have_xpath("//input[@id='bonus_how_many_goals']")

      expect(rendered).not_to have_content(I18n.t('no_champion_tip'))
      expect(rendered).not_to have_content(I18n.t('no_second_tip'))
      expect(rendered).not_to have_content(I18n.t('no_when_first_goal_tip'))
      expect(rendered).not_to have_content(I18n.t('no_how_many_goals_tip'))
    end

  end

  context 'when tournament ROUND_OF_16 is started' do
    before :each do
      allow(Tournament).to receive(:round_of_16_not_yet_started?).and_return(false)
    end

    it 'and no bonus tip was made' do
      assign(:presenter, presenter)

      render

      expect(rendered).to have_selector('h3', :text => I18n.t('your_bonustips'))

      expect(rendered).not_to have_xpath("//form[@action='/bonus_tips']")
      expect(rendered).not_to have_xpath("//select[@id='bonus_champion_team_id']")
      expect(rendered).not_to have_xpath("//select[@id='bonus_second_team_id']")
      expect(rendered).not_to have_xpath("//select[@id='bonus_when_final_first_goal']")
      expect(rendered).not_to have_xpath("//input[@id='bonus_how_many_goals']")

      expect(rendered).to have_content(I18n.t('no_champion_tip'))
      expect(rendered).to have_content(I18n.t('no_second_tip'))
      expect(rendered).to have_content(I18n.t('no_when_first_goal_tip'))
      expect(rendered).to have_content(I18n.t('no_how_many_goals_tip'))

    end
  end
end
