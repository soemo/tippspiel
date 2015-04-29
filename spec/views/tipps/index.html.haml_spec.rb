# -*- encoding : utf-8 -*-
require 'rails_helper'

describe 'tipps/index.html.haml', :type => :view do
  before :each do
    @user = create(:user)
    allow(view).to receive(:current_user).and_return(@user)
  end


  context 'when before_tournament == true' do
    before :each do
      controller.singleton_class.class_eval do
        protected
        def before_tournament?
          true
        end
        helper_method :before_tournament?
      end
    end

    it 'shows info to select champion' do

      render

      expect(rendered).to have_selector('h3', :text => I18n.t('tipps'))
      expect(rendered).to have_selector('b', :text => I18n.t('need_champion_tipp'))
      expect(rendered).to have_content(I18n.t('need_champion_tipp_info', :points => Users::UpdatePoints::CHAMPION_TIPP_POINTS))

      expect(rendered).to have_xpath("//form[@action='/save-champion-tipp']") do |form|
        expect(form).to have_selector('label', :text => I18n.t('who_will_be_champion'))
      end
    end

  end

  context 'when before_tournament == false' do
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
      expect(rendered).to have_content(I18n.t('no_champion_tipp'))

    end
  end

end
