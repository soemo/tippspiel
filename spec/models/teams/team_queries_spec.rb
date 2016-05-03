require 'rails_helper'

describe TeamQueries do

  subject { TeamQueries }

  describe '::all_ordered_by_name' do

    it 'returns teams ordered by name' do
      team1 = Team.create(name: 'baa')
      team2 = Team.create(name: 'aba')
      team3 = Team.create(name: 'aza')
      team4 = Team.create(name: 'aaa')

      expect(subject.all_ordered_by_name) .to eq([
                                                     team4,
                                                     team2,
                                                     team3,
                                                     team1
                                                 ])
    end
  end


end