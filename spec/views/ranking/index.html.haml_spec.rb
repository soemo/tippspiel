# -*- encoding : utf-8 -*-
require 'rails_helper'

describe 'ranking/index', :type => :view do

  before :each do
    allow(Tournament).to receive(:started?).and_return(true)
  end

  it 'should show no user ranking if no user' do
    assign(:user_count, 0)

    render

    expect(rendered).to have_selector('h3', :text => I18n.t('ranking'))
    expect(rendered).to have_selector('p', :text => I18n.t('x_user_bet', :user_count => 0))
    expect(rendered).to have_selector('p', :text => I18n.t('no_user'))
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

    assign(:user_ranking_hash, Users::PrepareRanking.call(:users_for_ranking => users))

    render

    expect(rendered).to have_selector('h3', :text => I18n.t('ranking'))
    expect(rendered).to have_selector('p', :text => I18n.t('x_user_bet', :user_count => user_count))

    expect(rendered).to have_selector('table.ranking') do |table|
      expect(table).to have_selector('thead') do |thead|
        expect(thead).to have_selector('th', :text => I18n.t('standings'))
        expect(thead).to have_selector('th', :text => User.human_attribute_name('name'))
        expect(thead).to have_selector('th', :text => Game.human_attribute_name('siegertipp'))
        expect(thead).to have_selector('th', :text => User.human_attribute_name('points'))
      end
      expect(table).to have_selector('tbody') do |tbody|
        expect(tbody).to have_selector('tr', :count => user_size)
        user_size.times do |index|
          expect(tbody).to have_selector('tr') do |tr|
            expect(tr).to have_selector('td.place', :text => '1')
            expect(tr).to have_selector('td', :text => "test user#{index}")
            expect(tr).to have_selector('a.statistic_popover', :text => "#{points}")
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

     assign(:user_ranking_hash, Users::PrepareRanking.call(:users_for_ranking => users))

     render

     expect(rendered).to have_selector('h3', :text => I18n.t('ranking'))
     expect(rendered).to have_selector('p', :text => I18n.t('x_user_bet', :user_count => user_count))

     expect(rendered).to have_selector('table.ranking') do |table|
       expect(table).to have_selector('thead') do |thead|
         expect(thead).to have_selector('th', :text => I18n.t('standings'))
         expect(thead).to have_selector('th', :text => User.human_attribute_name('name'))
         expect(thead).to have_selector('th', :text => Game.human_attribute_name('siegertipp'))
         expect(thead).to have_selector('th', :text => User.human_attribute_name('points'))
       end
       expect(table).to have_selector('tbody') do |tbody|
         expect(tbody).to have_selector('tr', :count => user_size)

         user_poins.each do |key, data|
           expect(tbody).to have_selector('tr') do |tr|
             expect(tr).to have_selector('td.place', :text => data[:place].to_s)
             expect(tr).to have_selector('td', :text => "test user_key_#{key}")
             expect(tr).to have_selector('a.statistic_popover', :text => data[:points].to_s)
           end
         end

       end
     end

   end
end
