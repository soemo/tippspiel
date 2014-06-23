# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'ranking/index.html.haml' do

  before :each do
    controller.singleton_class.class_eval do
      protected
      def before_tournament?
        false
      end
      helper_method :before_tournament?
    end
  end

  it 'should show no user ranking if no user' do
    assign(:user_count, 0)

    render

    rendered.should have_selector(:h3, :content => I18n.t('ranking'))
    rendered.should have_selector(:p, :content => I18n.t('x_user_bet', :user_count => 0))
    rendered.should have_selector(:p, :content => I18n.t('no_user'))
  end

  it 'should show correct user ranking - all user on place 1' do
    User.delete_all # fixture users delete
    user_size  = 10
    user_count = assign(:user_count, user_size)

    # 10 User anlegen
    users = []
    points = 13
    user_size.times do |index|
      users << FactoryGirl.build(:user,
                                 :lastname => "user#{index}",
                                 :points => points,
                                 :confirmed_at => Time.now - 5.minutes)
    end

    assign(:user_ranking_hash, User.prepare_user_ranking(users))

    render

    rendered.should have_selector(:h3, :content => I18n.t('ranking'))
    rendered.should have_selector(:p, :content => I18n.t('x_user_bet', :user_count => user_count))

    rendered.should have_selector(:table, :class => 'table table-striped table-condensed ranking') do |table|
      table.should have_selector(:thead) do |thead|
        thead.should have_selector(:th, :content => I18n.t('standings'))
        thead.should have_selector(:th, :content => User.human_attribute_name('name'))
        thead.should have_selector(:th, :content => Game.human_attribute_name('siegertipp'))
        thead.should have_selector(:th, :content => User.human_attribute_name('points'))
      end
      table.should have_selector(:tbody) do |tbody|
        tbody.should have_selector(:tr, :count => user_size)
        user_size.times do |index|
          tbody.should have_selector(:tr) do |tr|
            tr.should have_selector(:td, :class=>'place', :content => '1')
            tr.should have_selector(:td, :content => "test user#{index}")
            tr.should have_selector(:a, :class => 'statistic_popover', :content => "#{points}")
          end
        end
      end
    end
  end

  it 'should show correct user ranking - different points' do
     User.delete_all # fixture users delete

     user_poins = {
         0 => {:points => 11, :place => 1},
         1 => {:points => 10, :place => 2},
         2 => {:points => 10, :place => 2},
         3 => {:points => 10, :place => 2},
         4 => {:points => 8,  :place => 5},
         5 => {:points => 7,  :place => 6},
         6 => {:points => 7,  :place => 6},
         7 => {:points => 6,  :place => 8},
         8 => {:points => 2,  :place => 9},
         9 => {:points => 2,  :place => 9}
     }

     user_size  = user_poins.count
     user_count = assign(:user_count, user_size)

     # User anlegen
     users = []
     user_poins.each do |key, data|
       users << FactoryGirl.build(:user,
                                  :lastname => "user_key_#{key}",
                                  :points => data[:points],
                                  :confirmed_at => Time.now - 5.minutes)
     end

     assign(:user_ranking_hash, User.prepare_user_ranking(users))

     render

     rendered.should have_selector(:h3, :content => I18n.t('ranking'))
     rendered.should have_selector(:p, :content => I18n.t('x_user_bet', :user_count => user_count))

     rendered.should have_selector(:table, :class => 'table table-striped table-condensed ranking') do |table|
       table.should have_selector(:thead) do |thead|
         thead.should have_selector(:th, :content => I18n.t('standings'))
         thead.should have_selector(:th, :content => User.human_attribute_name('name'))
         thead.should have_selector(:th, :content => Game.human_attribute_name('siegertipp'))
         thead.should have_selector(:th, :content => User.human_attribute_name('points'))
       end
       table.should have_selector(:tbody) do |tbody|
         tbody.should have_selector(:tr, :count => user_size)

         user_poins.each do |key, data|
           tbody.should have_selector(:tr) do |tr|
             tr.should have_selector(:td, :class=>'place', :content => data[:place].to_s)
             tr.should have_selector(:td, :content => "test user_key_#{key}")
             tr.should have_selector(:a, :class => 'statistic_popover', :content => data[:points].to_s)
           end
         end

       end
     end

     #pp rendered
   end
end
