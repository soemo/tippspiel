require 'rails_helper'

describe Tipps::Compare do

  let!(:game1){create(:game)}
  let!(:game2){create(:game)}
  let!(:game3){create(:game)}


  subject { Tipps::Compare }

  before :each do
    Timecop.freeze(Time.now)
    game1.update_column(:start_at, Time.now - 1.minute)
    game2.update_column(:start_at, Time.now + 1.minute)
    game3.update_column(:start_at, Time.now + 1.day)
  end

  context '#get_possible_games' do

    it 'returns games where start_date < Time.now' do
      games = subject.new.send(:get_possible_games)
      expect(games).to eq([game1])

      game2.update_column(:start_at, Time.now)
      games = subject.new.send(:get_possible_games)
      expect(games).to eq([game1])

      game2.update_column(:start_at, Time.now - 1.second)
      games = subject.new.send(:get_possible_games)
      expect(games).to eq([game1, game2])
    end
  end

end