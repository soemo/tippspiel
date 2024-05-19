# -*- encoding : utf-8 -*-
require 'rails_helper'

describe 'rankings/index', :type => :view do

  let(:presenter) {RankingPresenter.new}

  before :each do
    allow(Tournament).to receive(:round_of_16_not_yet_started?).and_return(true)
  end

  it 'should show no user ranking if no user' do
    assign(:presenter, presenter)
    expect(presenter).to receive(:user_count).and_return(0)
    expect(presenter).to receive(:bonus_answers_visible?).and_return(false)

    render

    expect(rendered).to have_selector('h3', :text => I18n.t('ranking'))
    expect(rendered).to have_selector('p', :text => I18n.t('x_user_bet', :user_count => 0))
    expect(rendered).to have_selector('p', :text => I18n.t('no_user'))
  end

  it 'should show correct user ranking - all user on place 1' do
    User.delete_all # fixture users delete

    assign(:presenter, presenter)
    user_size  = 10
    expect(presenter).to receive(:user_count).and_return(user_size)
    # 2x10 + one time in the index
    expect(presenter).to receive(:bonus_answers_visible?).exactly(21).times.and_return(false)

    # create 10 users
    users = []
    points = 13
    user_size.times do |index|
      users << FactoryBot.build(:user,
                                 id: index+1,
                                 :lastname => "user#{index}",
                                 :points => points,
                                 :confirmed_at => Time.now - 5.minutes)
    end
    expect(presenter).to receive(:user_ranking_hash).and_return(Users::PrepareRanking.call(:users_for_ranking => users))

    render

    expect(rendered).to have_selector('h3', :text => I18n.t('ranking'))
    expect(rendered).to have_selector('p', :text => I18n.t('x_user_bet', :user_count => user_size))

    expect(rendered).to have_selector('table.ranking.hover') do |table|
      expect(table).to have_selector('thead') do |thead|
        expect(thead).to have_selector('th', :text => I18n.t('standings'))
        expect(thead).to have_selector('th', :text => User.human_attribute_name('name'))
        expect(thead).to have_selector('th', :text => Game.human_attribute_name('bonus'))
        expect(thead).to have_selector('th', :text => User.human_attribute_name('points'))
      end
      expect(table).to have_selector('tbody') do |tbody|
        expect(tbody).to have_selector('tr', :count => user_size)
        expect(tbody).to have_selector('tr#place_1', :count => user_size)
        expect(tbody).to have_selector('tr#place_1 > td.show-for-small-only > div.row > div > span.place', :count => user_size, :text => '1')
        expect(tbody).to have_selector('tr#place_1 > td.hide-for-small-only.place', :count => user_size, :text => '1')
        user_size.times do |index|
          expect(tbody).to have_selector('tr#place_1 > td.show-for-small-only', :text => "test user#{index}")
          expect(tbody).to have_selector('tr#place_1 > td.show-for-small-only > div > div > div > div > span', :text => "#{points}")
          expect(tbody).to have_selector('tr#place_1 > td.hide-for-small-only', :text => "test user#{index}")
          expect(tbody).to have_selector('tr#place_1 > td.hide-for-small-only > span', :text => "#{points}")
        end
      end
    end
  end

  it 'should show correct user ranking - different points' do
     User.delete_all # fixture users delete

     assign(:presenter, presenter)

     user_points = {
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

     user_size  = user_points.count
     expect(presenter).to receive(:user_count).and_return(user_size)
     # 2x10 + one time in the index
     expect(presenter).to receive(:bonus_answers_visible?).exactly(21).times.and_return(false)

     # create users
     users = []
     user_points.each do |key, data|
       users << FactoryBot.build(:user,
                                  id: key + 1,
                                  :lastname => "user_key_#{key}",
                                  :points => data[:points],
                                  :confirmed_at => Time.now - 5.minutes)
     end
     expect(presenter).to receive(:user_ranking_hash).and_return(Users::PrepareRanking.call(:users_for_ranking => users))

     render

     expect(rendered).to have_selector('h3', :text => I18n.t('ranking'))
     expect(rendered).to have_selector('p', :text => I18n.t('x_user_bet', :user_count => user_size))

     expect(rendered).to have_selector('table.ranking') do |table|
       expect(table).to have_selector('thead') do |thead|
         expect(thead).to have_selector('th', :text => I18n.t('standings'))
         expect(thead).to have_selector('th', :text => User.human_attribute_name('name'))
         expect(thead).to have_selector('th', :text => Game.human_attribute_name('bonus'))
         expect(thead).to have_selector('th', :text => User.human_attribute_name('points'))
       end

       expect(table).to have_selector('tbody') do |tbody|
         expect(tbody).to have_selector('tr', :count => user_size)
         expect(tbody).to have_selector('tr#place_1', :count => 1)
         expect(tbody).to have_selector('tr#place_2', :count => 3)
         expect(tbody).to have_selector('tr#place_3', :count => 0)
         expect(tbody).to have_selector('tr#place_4', :count => 0)
         expect(tbody).to have_selector('tr#place_5', :count => 1)
         expect(tbody).to have_selector('tr#place_6', :count => 2)
         expect(tbody).to have_selector('tr#place_7', :count => 0)
         expect(tbody).to have_selector('tr#place_8', :count => 1)
         expect(tbody).to have_selector('tr#place_9', :count => 2)

         #place 1
         expect(tbody).to have_selector('tr#place_1 > td.show-for-small-only', :text => "test user_key_0")
         expect(tbody).to have_selector('tr#place_1 > td.show-for-small-only > div > div > div > div > span', :text => "11", :count => 1)
         expect(tbody).to have_selector('tr#place_1 > td.hide-for-small-only', :text => "test user_key_0")
         expect(tbody).to have_selector('tr#place_1 > td.hide-for-small-only > span', :text => "11", :count => 1)
         #place 2
         expect(tbody).to have_selector('tr#place_2 > td.show-for-small-only', :text => "test user_key_1")
         expect(tbody).to have_selector('tr#place_2 > td.show-for-small-only', :text => "test user_key_2")
         expect(tbody).to have_selector('tr#place_2 > td.show-for-small-only', :text => "test user_key_3")
         expect(tbody).to have_selector('tr#place_2 > td.show-for-small-only > div > div > div > div > span', :text => "10", :count => 3)
         expect(tbody).to have_selector('tr#place_2 > td.hide-for-small-only', :text => "test user_key_1")
         expect(tbody).to have_selector('tr#place_2 > td.hide-for-small-only', :text => "test user_key_2")
         expect(tbody).to have_selector('tr#place_2 > td.hide-for-small-only', :text => "test user_key_3")
         expect(tbody).to have_selector('tr#place_2 > td.hide-for-small-only > span', :text => "10", :count => 3)
         #place 5
         expect(tbody).to have_selector('tr#place_5 > td.show-for-small-only', :text => "test user_key_4")
         expect(tbody).to have_selector('tr#place_5 > td.show-for-small-only > div > div > div > div > span', :text => "8", :count => 1)
         expect(tbody).to have_selector('tr#place_5 > td.hide-for-small-only', :text => "test user_key_4")
         expect(tbody).to have_selector('tr#place_5 > td.hide-for-small-only > span', :text => "8", :count => 1)
         # place 6
         expect(tbody).to have_selector('tr#place_6 > td.show-for-small-only', :text => "test user_key_5")
         expect(tbody).to have_selector('tr#place_6 > td.show-for-small-only', :text => "test user_key_6")
         expect(tbody).to have_selector('tr#place_6 > td.show-for-small-only > div > div > div > div > span', :text => "7", :count => 2)
         expect(tbody).to have_selector('tr#place_6 > td.hide-for-small-only', :text => "test user_key_5")
         expect(tbody).to have_selector('tr#place_6 > td.hide-for-small-only', :text => "test user_key_6")
         expect(tbody).to have_selector('tr#place_6 > td.hide-for-small-only > span', :text => "7", :count => 2)
         # place 8
         expect(tbody).to have_selector('tr#place_8 > td.show-for-small-only', :text => "test user_key_7")
         expect(tbody).to have_selector('tr#place_8 > td.show-for-small-only > div > div > div > div > span', :text => "6", :count => 1)
         expect(tbody).to have_selector('tr#place_8 > td.hide-for-small-only', :text => "test user_key_7")
         expect(tbody).to have_selector('tr#place_8 > td.hide-for-small-only > span', :text => "6", :count => 1)
         # place 9
         expect(tbody).to have_selector('tr#place_9 > td.show-for-small-only', :text => "test user_key_8")
         expect(tbody).to have_selector('tr#place_9 > td.show-for-small-only', :text => "test user_key_9")
         expect(tbody).to have_selector('tr#place_9 > td.show-for-small-only > div > div > div > div > span', :text => "2", :count => 2)
         expect(tbody).to have_selector('tr#place_9 > td.hide-for-small-only', :text => "test user_key_8")
         expect(tbody).to have_selector('tr#place_9 > td.hide-for-small-only', :text => "test user_key_9")
         expect(tbody).to have_selector('tr#place_9 > td.hide-for-small-only > span', :text => "2", :count => 2)
       end
     end
   end
end
