require 'rails_helper'

describe TeamQueries do

  subject { TeamQueries }

  describe '::last_updated_at' do

    it 'returns max updated_at' do
      Timecop.freeze(Time.now)
      team1 = create(:team)
      team2 = create(:team)
      team1.update_column(:updated_at, Time.now + 5.minutes)
      expect(subject.last_updated_at).to be_equal_to_time(team1.updated_at)

      team2.update_column(:updated_at, Time.now + 10.minutes)
      expect(subject.last_updated_at).to be_equal_to_time(team2.updated_at)
    end
  end

end