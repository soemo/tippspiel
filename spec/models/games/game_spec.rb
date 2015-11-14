# -*- encoding : utf-8 -*-
require 'rails_helper'

describe Game, :type => :model do

  it 'create' do
    Game.create!({:start_at => '19.06.2012 20:45', :place => 'Ort',
                  :team1_id => 1, :team2_id => 2, :group=> Game::GROUP_D,
                  :round => Game::GROUP, :api_match_id => 1})
    Game.create!({:start_at => '19.06.2012 20:45', :place => 'Ort',
                  :team1_placeholder_name => 'D2', :team2_placeholder_name => 'D3',
                  :group=> 'D', :round => Game::GROUP, :api_match_id => 2})
  end

  it 'not create' do
    expect{Game.create!({:start_at => '19.06.2012 20:45',
                         :place => 'Ort', :team1_id => 1,
                         :group=> Game::GROUP_D,
                         :round => Game::GROUP})}.to raise_error(ActiveRecord::RecordInvalid)
    expect{Game.create!({:start_at => '19.06.2012 20:45',
                         :place => 'Ort', :team2_id => 2,
                         :group=> Game::GROUP_D,
                         :round => Game::GROUP})}.to raise_error(ActiveRecord::RecordInvalid)
    expect{Game.create!({:start_at => '19.06.2012 20:45',
                         :place => 'Ort',
                         :team1_placeholder_name => 'test1',
                         :group=> Game::GROUP_D,
                         :round => Game::GROUP})}.to raise_error(ActiveRecord::RecordInvalid)
    expect{Game.create!({:start_at => '19.06.2012 20:45',
                         :place => 'Ort',
                         :team2_placeholder_name => 'test2',
                         :group=> Game::GROUP_D,
                         :round => Game::GROUP})}.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'gets finished games' do
     game1 = create(:game, :start_at => '19.06.2012 20:45', :finished => nil)
     game2 = create(:game, :start_at => '19.06.2012 20:45', :finished => false)
     game3 = create(:game, :start_at => '19.06.2012 20:45', :finished => true)

     expect(Game.finished).to eq([game3])
  end

end
