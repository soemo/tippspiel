# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'tipps/index.html.haml'do
  before :each do
    @user = User.first
    5.times{FactoryGirl.create(:game)}

    view.stub(:current_user).and_return(@user)
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
      assign(:user_tipps, Tipp.user_tipps(@user.id))

      render

      rendered.should have_selector(:h3, :content => I18n.t('tipps'))
      rendered.should have_selector(:div, :class => 'alert alert-info') do |div|
        div.should have_selector(:b, :content => I18n.t('need_champion_tipp'))
        div.should have_selector(:span, :content => I18n.t('need_champion_tipp_info'))
      end

      rendered.should have_selector(:form, :action => '/save-champion-tipp') do |form|
        form.should have_selector(:label, :content => I18n.t('who_will_be_champion'))
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

      rendered.should have_selector(:h3, :content => I18n.t('tipps'))
      rendered.should have_selector(:div, :class => 'alert alert-info') do |div|
        div.should have_selector(:span, :content => I18n.t('no_champion_tipp'))
      end

      end
  end

end
