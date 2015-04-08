# -*- encoding : utf-8 -*-
require 'rails_helper'

describe 'tipps/index.html.haml', :type => :view do
  before :each do
    @user = User.first
    5.times{FactoryGirl.create(:game)}

    allow(view).to receive(:current_user).and_return(@user)
  end


  describe 'before_tournament == true' do
    before :each do
      controller.singleton_class.class_eval do
        protected
        def before_tournament?
          true
        end
        helper_method :before_tournament?
      end
    end

    it 'should show info to select champion' do
      assign(:user_tipps, GetUserTipps.call(:user_id => @user.id))

      render

      expect(rendered).to have_selector('h3', :text => I18n.t('tipps'))
      expect(rendered).to have_selector('div.alert.alert-info') do |div|
        expect(div).to have_selector('b', :text => I18n.t('need_champion_tipp'))
        expect(div).to have_selector('span', :text => I18n.t('need_champion_tipp_info', :points => UpdateUserPoints::CHAMPION_TIPP_POINTS))
      end

      expect(rendered).to have_xpath("//form[@action='/save-champion-tipp']") do |form|
        expect(form).to have_selector('label', :text => I18n.t('who_will_be_champion'))
      end
    end

  end

  describe 'before_tournament == false' do
    before :each do
      controller.singleton_class.class_eval do
        protected
        def before_tournament?
          false
        end
        helper_method :before_tournament?
      end
    end

    it 'should say no champion tipp' do
      render

      expect(rendered).to have_selector('h3', :text => I18n.t('tipps'))
      expect(rendered).to have_selector('div.alert.alert-info') do |div|
        expect(div).to have_selector('span', :text => I18n.t('no_champion_tipp'))
      end

    end
  end

end
